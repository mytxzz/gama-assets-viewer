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

#include "CCTimelineAction.h"

using namespace cocos2d;

namespace cocostudio {
namespace timeline{

TimelineAction* TimelineAction::create()
{
    TimelineAction* object = new TimelineAction();
    if (object && object->init())
    {
        object->autorelease();
        return object;
    }
    CC_SAFE_DELETE(object);
    return nullptr;
}

TimelineAction::TimelineAction()
    : _duration(0)
    , _time(0)
    , _timeSpeed(1)
    , _frameInternal(1/60.0f)
    , _playing(false)
    , _currentFrame(0)
    , _endFrame(0)
{
}

TimelineAction::~TimelineAction()
{
}

bool TimelineAction::init()
{
    return true;
}

void TimelineAction::gotoFrameAndPlay(int startIndex)
{
    gotoFrameAndPlay(startIndex, true);
}

void TimelineAction::gotoFrameAndPlay(int startIndex, bool loop)
{
    gotoFrameAndPlay(startIndex, _duration, loop);
}

void TimelineAction::gotoFrameAndPlay(int startIndex, int endIndex, bool loop)
{
    _endFrame = endIndex;
    _loop = loop;
    _time =_currentFrame = startIndex;

    resume();
    gotoFrame(_currentFrame);
}

void TimelineAction::gotoFrameAndPause(int startIndex)
{
    _time =_currentFrame = startIndex;

    pause();
    gotoFrame(_currentFrame);
}

void TimelineAction::pause()
{
    _playing = false;
}

void TimelineAction::resume()
{
    _playing = true;
}

void TimelineAction::setTimeSpeed(float speed)
{
    _timeSpeed = speed;
}

float TimelineAction::getTimeSpeed()
{
    return _timeSpeed;
}

TimelineAction* TimelineAction::clone() const
{
    TimelineAction* newAction = TimelineAction::create();
    newAction->setDuration(_duration);
    newAction->setTimeSpeed(_timeSpeed);

    for (auto timelines : _timelineMap)
    {
        for(auto timeline : timelines.second)
        {      
            Timeline* newTimeline = timeline->clone();
            newAction->addTimeline(newTimeline);
        }
    }

    return newAction;
}

void TimelineAction::step(float delta)
{
    if (!_playing || _timelineMap.size() == 0 || _duration == 0)
    {
        return;
    }

    _time += delta * _timeSpeed;
    _currentFrame = (int)(_time / _frameInternal);

    if (_currentFrame > _endFrame)
    {
        _currentFrame = _time = 0;
        _playing = _loop;
        if(!_playing)
            return;
    }

    gotoFrame(_currentFrame);
}

typedef std::function<void(Node*)> tCallBack;
void foreachNodeDescendant(Node* parent, tCallBack callback)
{
    callback(parent);

    auto children = parent->getChildren();
    for (auto child : children)
    {
        foreachNodeDescendant(child, callback);
    }
}

void TimelineAction::startWithTarget(Node *target)
{
    Action::startWithTarget(target);

    foreachNodeDescendant(target, 
        [this, target](Node* child)
    {
        int actionTag = child->getTag();
        auto timelines = this->_timelineMap[actionTag];
        for (auto timeline : timelines)
        {
            timeline->setNode(child);
        }
    });
}

void TimelineAction::addTimeline(Timeline* timeline)
{
    int tag = timeline->getActionTag();
    if (_timelineMap.find(tag) == _timelineMap.end())
    {
        _timelineMap[tag] = cocos2d::Vector<Timeline*>();
    }

    if (!_timelineMap[tag].contains(timeline))
    {
        _timelineList.pushBack(timeline);
        _timelineMap[tag].pushBack(timeline);
    }
}

void TimelineAction::removeTimeline(Timeline* timeline)
{
    int tag = timeline->getActionTag();
    if (_timelineMap.find(tag) != _timelineMap.end())
    {
        if(_timelineMap[tag].contains(timeline))
        {
            _timelineMap[tag].eraseObject(timeline);
            _timelineList.eraseObject(timeline);
        }
    }
}

void TimelineAction::gotoFrame(int frameIndex)
{
    int size = _timelineList.size();
    for(int i = 0; i<size; i++)
    {      
        _timelineList.at(i)->gotoFrame(frameIndex);
    }
}

}
}
