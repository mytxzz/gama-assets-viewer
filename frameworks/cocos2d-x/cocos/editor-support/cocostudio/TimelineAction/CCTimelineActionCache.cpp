/****************************************************************************
Copyright (c) 2013 cocos2d-x.org

http://www.cocos2d-x.org

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
****************************************************************************/

#include "CCTimelineActionCache.h"
#include "CCTimelineAction.h"
#include "CCFrame.h"

using namespace cocos2d;

namespace cocostudio {
namespace timeline{

static const char* FrameType_VisibleFrame       = "VisibleFrame";
static const char* FrameType_PositionFrame      = "PositionFrame";
static const char* FrameType_ScaleFrame         = "ScaleFrame";
static const char* FrameType_RotationFrame      = "RotationFrame";
static const char* FrameType_SkewFrame          = "SkewFrame";
static const char* FrameType_RotationSkewFrame  = "RotationSkewFrame";
static const char* FrameType_AnchorFrame        = "AnchorFrame";
static const char* FrameType_InnerActionFrame   = "InnerActionFrame";
static const char* FrameType_ColorFrame         = "ColorFrame";


static const char* ACTION           = "action";
static const char* NAME             = "name";
static const char* DURATION         = "duration";
static const char* NODES            = "nodes";
static const char* TIMELINES        = "timelines";
static const char* FRAME_TYPE       = "frameType";
static const char* FRAMES           = "frames";
static const char* FRAME_INDEX      = "frameIndex";
static const char* VISIBLE          = "visible";
static const char* TWEEN            = "tween";
static const char* TIME_SPEED       = "speed";
static const char* ACTION_TAG       = "actionTag";
static const char* INNER_ACTION     = "innerActionType";
static const char* START_FRAME      = "startFrame";

static const char* X                = "x";
static const char* Y                = "y";
static const char* SCALE_X          = "scalex";
static const char* SCALE_Y          = "scaley";
static const char* SKEW_X           = "skewx";
static const char* SKEW_Y           = "skewy";
static const char* ROTATION         = "rotation";
static const char* ROTATION_SKEW_X  = "rotationSkewX";
static const char* ROTATION_SKEW_Y  = "rotationSkewY";
static const char* ANCHOR_X         = "anchorx";
static const char* ANCHOR_Y         = "anchory";
static const char* ALPHA            = "alpha";
static const char* RED              = "red";
static const char* GREEN            = "green";
static const char* BLUE             = "blue";


static TimelineActionCache* _sharedActionCache = nullptr;

TimelineActionCache* TimelineActionCache::getInstance()
{
    if (! _sharedActionCache)
    {
        _sharedActionCache = new TimelineActionCache();
        _sharedActionCache->init();
    }

    return _sharedActionCache;
}

void TimelineActionCache::destroyInstance()
{
    CC_SAFE_DELETE(_sharedActionCache);
}

void TimelineActionCache::purge()
{
    _animationActions.clear();
}

void TimelineActionCache::init()
{
    using namespace std::placeholders;
    _funcs.insert(Pair(FrameType_VisibleFrame,      std::bind(&TimelineActionCache::loadVisibleFrame,      this, _1)));
    _funcs.insert(Pair(FrameType_PositionFrame,     std::bind(&TimelineActionCache::loadPositionFrame,     this, _1)));
    _funcs.insert(Pair(FrameType_ScaleFrame,        std::bind(&TimelineActionCache::loadScaleFrame,        this, _1)));
    _funcs.insert(Pair(FrameType_RotationFrame,     std::bind(&TimelineActionCache::loadRotationFrame,     this, _1)));
    _funcs.insert(Pair(FrameType_SkewFrame,         std::bind(&TimelineActionCache::loadSkewFrame,         this, _1)));
    _funcs.insert(Pair(FrameType_RotationSkewFrame, std::bind(&TimelineActionCache::loadRotationSkewFrame, this, _1)));
    _funcs.insert(Pair(FrameType_AnchorFrame,       std::bind(&TimelineActionCache::loadAnchorPointFrame,  this, _1)));
    _funcs.insert(Pair(FrameType_InnerActionFrame,  std::bind(&TimelineActionCache::loadInnerActionFrame,  this, _1)));
    _funcs.insert(Pair(FrameType_ColorFrame,        std::bind(&TimelineActionCache::loadColorFrame,        this, _1)));
}

void TimelineActionCache::removeAction(const std::string& fileName)
{
    if (_animationActions.find(fileName) != _animationActions.end())
    {
        _animationActions.erase(fileName);
    }
}

TimelineAction* TimelineActionCache::createAction(const std::string& fileName)
{
    TimelineAction* action = _animationActions.at(fileName);
    if (action == nullptr)
    {
        action = loadAnimationActionWithFile(fileName);
    }
    return action->clone();
}

TimelineAction* TimelineActionCache::loadAnimationActionWithFile(const std::string& fileName)
{
    // Read content from file
    std::string fullPath    = CCFileUtils::getInstance()->fullPathForFilename(fileName);
    std::string contentStr  = FileUtils::getInstance()->getStringFromFile(fullPath);

    return loadAnimationActionWithContent(fileName, contentStr);
}

TimelineAction* TimelineActionCache::loadAnimationActionWithContent(const std::string&fileName, const std::string& content)
{
    // if already exists an action with filename, then return this action
    TimelineAction* action = _animationActions.at(fileName);
    if(action)
        return action;

    rapidjson::Document doc;
    doc.Parse<0>(content.c_str());
    if (doc.HasParseError()) 
    {
        CCLOG("GetParseError %s\n", doc.GetParseError());
    }

    const rapidjson::Value& json = DICTOOL->getSubDictionary_json(doc, ACTION);

    action = TimelineAction::create();

    action->setDuration(DICTOOL->getIntValue_json(json, DURATION));
    action->setTimeSpeed(DICTOOL->getFloatValue_json(json, TIME_SPEED, 1.0f));

    int timelineLength = DICTOOL->getArrayCount_json(json, TIMELINES);
    for (int i = 0; i<timelineLength; i++)
    {
        const rapidjson::Value& dic = DICTOOL->getSubDictionary_json(json, TIMELINES, i);
        Timeline* timeline = loadTimeline(dic);

        if(timeline)
            action->addTimeline(timeline);
    }

    _animationActions.insert(fileName, action);

    return action;
}


Timeline* TimelineActionCache::loadTimeline(const rapidjson::Value& json)
{
    Timeline* timeline = nullptr;

    // get frame type 
    const char* frameType = DICTOOL->getStringValue_json(json, FRAME_TYPE);

    if(frameType && _funcs.find(frameType) != _funcs.end())
    {
        timeline = Timeline::create();

        int actionTag = DICTOOL->getIntValue_json(json, ACTION_TAG);
        timeline->setActionTag(actionTag);

        FrameCreateFunc func = _funcs.at(frameType);

        int length = DICTOOL->getArrayCount_json(json, FRAMES);
        for (int i = 0; i<length; i++)
        {
            const rapidjson::Value& dic = DICTOOL->getSubDictionary_json(json, FRAMES, i);

            Frame* frame = nullptr;

            if (func != nullptr)
            {
                frame = func(dic);

                int frameIndex = DICTOOL->getIntValue_json(dic, FRAME_INDEX);
                frame->setFrameIndex(frameIndex);

                bool tween = DICTOOL->getBooleanValue_json(dic, TWEEN, false);
                frame->setTween(tween);
            }

            timeline->getFrames().pushBack(frame);
        }
    }

    return timeline;
}

Frame* TimelineActionCache::loadVisibleFrame(const rapidjson::Value& json)
{
    VisibleFrame* frame = VisibleFrame::create();

    bool visible = DICTOOL->getBooleanValue_json(json, VISIBLE);
    frame->setVisible(visible);

    return frame;
}

Frame* TimelineActionCache::loadPositionFrame(const rapidjson::Value& json)
{
    PositionFrame* frame = PositionFrame::create();

    float x = DICTOOL->getFloatValue_json(json, X);
    float y = DICTOOL->getFloatValue_json(json, Y);
    frame->setPosition(Point(x,y));

    return frame;
}

Frame* TimelineActionCache::loadScaleFrame(const rapidjson::Value& json)
{
   ScaleFrame* frame = ScaleFrame::create();

   float scalex = DICTOOL->getFloatValue_json(json, SCALE_X);
   float scaley = DICTOOL->getFloatValue_json(json, SCALE_Y);

   frame->setScaleX(scalex);
   frame->setScaleY(scaley);

    return frame;
}

Frame* TimelineActionCache::loadSkewFrame(const rapidjson::Value& json)
{
    SkewFrame* frame = SkewFrame::create();

    float skewx = DICTOOL->getFloatValue_json(json, SKEW_X);
    float skewy = DICTOOL->getFloatValue_json(json, SKEW_Y);

    frame->setSkewX(skewx);
    frame->setSkewY(skewy);

    return frame;
}

Frame* TimelineActionCache::loadRotationSkewFrame(const rapidjson::Value& json)
{
    RotationSkewFrame* frame = RotationSkewFrame::create();

    float skewx = DICTOOL->getFloatValue_json(json, ROTATION_SKEW_X);
    float skewy = DICTOOL->getFloatValue_json(json, ROTATION_SKEW_Y);

    frame->setSkewX(skewx);
    frame->setSkewY(skewy);

    return frame;
}

Frame* TimelineActionCache::loadRotationFrame(const rapidjson::Value& json)
{
    RotationFrame* frame = RotationFrame::create();

    float rotation = DICTOOL->getFloatValue_json(json, ROTATION);
    frame->setRotation(rotation);

    return frame;
}

Frame* TimelineActionCache::loadAnchorPointFrame (const rapidjson::Value& json)
{
    AnchorPointFrame* frame = AnchorPointFrame::create();

    float anchorx = DICTOOL->getFloatValue_json(json, ANCHOR_X);
    float anchory = DICTOOL->getFloatValue_json(json, ANCHOR_Y);

    frame->setAnchorPoint(Point(anchorx, anchory));

    return frame;
}

Frame* TimelineActionCache::loadInnerActionFrame(const rapidjson::Value& json)
{
    InnerActionFrame* frame = InnerActionFrame::create();

    InnerActionType type = (InnerActionType)DICTOOL->getIntValue_json(json, INNER_ACTION);
    int startFrame       = DICTOOL->getIntValue_json(json, START_FRAME); 

    frame->setInnerActionType(type);
    frame->setStartFrameIndex(startFrame);

    return frame;
}

Frame* TimelineActionCache::loadColorFrame(const rapidjson::Value& json)
{
    ColorFrame* frame = ColorFrame::create();

    GLubyte alpha = (GLubyte)DICTOOL->getIntValue_json(json, ALPHA);
    GLubyte red   = (GLubyte)DICTOOL->getIntValue_json(json, RED);
    GLubyte green = (GLubyte)DICTOOL->getIntValue_json(json, GREEN);
    GLubyte blue  = (GLubyte)DICTOOL->getIntValue_json(json, BLUE);

    frame->setAlpha(alpha);
    frame->setColor(Color3B(red, green, blue));

    return frame;
}


}
}