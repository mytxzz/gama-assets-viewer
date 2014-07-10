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

#include "CCNodeCache.h"
#include "CCTimelineActionCache.h"
#include "CCFrame.h"

#include "CCSGUIReader.h"

using namespace cocos2d;
using namespace cocos2d::ui;

namespace cocostudio {
namespace timeline{


static const char* ClassName_Node     = "Node";
static const char* ClassName_SubGraph = "SubGraph";
static const char* ClassName_Sprite   = "Sprite";
static const char* ClassName_Particle = "Particle";

static const char* ClassName_Panel     = "Panel";
static const char* ClassName_Button     = "Button";
static const char* ClassName_CheckBox   = "CheckBox";
static const char* ClassName_ImageView  = "ImageView";
static const char* ClassName_TextAtlas  = "TextAtlas";
static const char* ClassName_TextBMFont = "TextBMFont";
static const char* ClassName_Text       = "Text";
static const char* ClassName_LoadingBar = "LoadingBar";
static const char* ClassName_TextField  = "TextField";
static const char* ClassName_Slider     = "Slider";
static const char* ClassName_Layout     = "Layout";
static const char* ClassName_ScrollView = "ScrollView";
static const char* ClassName_ListView   = "ListView";
static const char* ClassName_PageView   = "PageView";
static const char* ClassName_Widget     = "Widget";


static const char* NODE        = "nodeTree";
static const char* CHILDREN    = "children";
static const char* CLASSNAME   = "classname";
static const char* FILE_PATH   = "filePath";
static const char* PLIST_FILE  = "plistFile";
static const char* ACTION_TAG  = "actionTag";

static const char* OPTIONS     = "options";

static const char* WIDTH            = "width";
static const char* HEIGHT           = "height";
static const char* X                = "x";
static const char* Y                = "y";
static const char* SCALE_X          = "scaleX";
static const char* SCALE_Y          = "scaleY";
static const char* SKEW_X           = "skewX";
static const char* SKEW_Y           = "skewY";
static const char* ROTATION         = "rotation";
static const char* ROTATION_SKEW_X  = "rotationSkewX";
static const char* ROTATION_SKEW_Y  = "rotationSkewY";
static const char* ANCHOR_X         = "anchorPointX";
static const char* ANCHOR_Y         = "anchorPointY";
static const char* ALPHA            = "opacity";
static const char* RED              = "colorR";
static const char* GREEN            = "colorG";
static const char* BLUE             = "colorB";
static const char* PARTICLE_NUM     = "particleNum";
    
static const char* MULRESPOSITION              = "mulResPosition";
static const char* POSITIONTYPE                = "positionType";
static const char* MUL_POSITION                = "position";
static const char* MUL_POSITIONX               = "x";
static const char* MUL_POSITIONY               = "y";
static const char* MUL_POSITIONPERCENTAGE      = "percentagepos";
static const char* MUL_POSITIONPERCENTAGEX     = "x";
static const char* MUL_POSITIONPERCENTAGEY     = "y";
static const char* MUL_RELATIVEALIGN           = "mulpositionpercentage";
static const char* MUL_MARGIN                  = "margin";
static const char* MUL_MARGIN_LEFT             = "left";
static const char* MUL_MARGIN_TOP              = "top";
static const char* MUL_MARGIN_RIGHT            = "right";
static const char* MUL_MARGIN_BOTTOM           = "bottom";


static NodeCache* _sharedNodeCache = nullptr;

NodeCache* NodeCache::getInstance()
{
    if (! _sharedNodeCache)
    {
        _sharedNodeCache = new NodeCache();
        _sharedNodeCache->init();
    }

    return _sharedNodeCache;
}

void NodeCache::destroyInstance()
{
    CC_SAFE_DELETE(_sharedNodeCache);
}

void NodeCache::purge()
{
    _nodes.clear();
}

void NodeCache::init()
{
    using namespace std::placeholders;

    _funcs.insert(Pair(ClassName_Node,      std::bind(&NodeCache::loadSimpleNode, this, _1)));
    _funcs.insert(Pair(ClassName_SubGraph,  std::bind(&NodeCache::loadSubGraph,   this, _1)));
    _funcs.insert(Pair(ClassName_Sprite,    std::bind(&NodeCache::loadSprite,     this, _1)));
    _funcs.insert(Pair(ClassName_Particle,  std::bind(&NodeCache::loadParticle,   this, _1)));

    _funcs.insert(Pair(ClassName_Panel,    std::bind(&NodeCache::loadWidget,   this, _1)));
    _funcs.insert(Pair(ClassName_Button,    std::bind(&NodeCache::loadWidget,   this, _1)));
    _funcs.insert(Pair(ClassName_CheckBox,  std::bind(&NodeCache::loadWidget,   this, _1)));
    _funcs.insert(Pair(ClassName_ImageView, std::bind(&NodeCache::loadWidget,   this, _1)));
    _funcs.insert(Pair(ClassName_TextAtlas, std::bind(&NodeCache::loadWidget,   this, _1)));
    _funcs.insert(Pair(ClassName_TextBMFont,std::bind(&NodeCache::loadWidget,   this, _1)));
    _funcs.insert(Pair(ClassName_Text,      std::bind(&NodeCache::loadWidget,   this, _1)));
    _funcs.insert(Pair(ClassName_LoadingBar,std::bind(&NodeCache::loadWidget,   this, _1)));
    _funcs.insert(Pair(ClassName_TextField, std::bind(&NodeCache::loadWidget,   this, _1)));
    _funcs.insert(Pair(ClassName_Slider,    std::bind(&NodeCache::loadWidget,   this, _1)));
    _funcs.insert(Pair(ClassName_Layout,    std::bind(&NodeCache::loadWidget,   this, _1)));
    _funcs.insert(Pair(ClassName_ScrollView,std::bind(&NodeCache::loadWidget,   this, _1)));
    _funcs.insert(Pair(ClassName_ListView,  std::bind(&NodeCache::loadWidget,   this, _1)));
    _funcs.insert(Pair(ClassName_PageView,  std::bind(&NodeCache::loadWidget,   this, _1)));
    _funcs.insert(Pair(ClassName_Widget,    std::bind(&NodeCache::loadWidget,   this, _1)));

    _guiReader = new WidgetPropertiesReader0300();
}

cocos2d::Node* NodeCache::createNode(const std::string& filename)
{
    cocos2d::Node* node = _nodes.at(filename);
    if (node == nullptr)
    {
        node = loadNodeWithFile(filename);

//         if(cache)
//             _nodes.insert(filename, node);
    }

    return node;
}

cocos2d::Node* NodeCache::loadNodeWithFile(const std::string& fileName)
{
    // Read content from file
    std::string fullPath = CCFileUtils::getInstance()->fullPathForFilename(fileName);
    std::string contentStr = FileUtils::getInstance()->getStringFromFile(fullPath);

    // Load animation data from file
    TimelineActionCache::getInstance()->loadAnimationActionWithContent(fileName, contentStr);

    return loadNodeWithContent(contentStr);
}

cocos2d::Node* NodeCache::loadNodeWithContent(const std::string& content)
{
    rapidjson::Document doc;
    doc.Parse<0>(content.c_str());
    if (doc.HasParseError()) {
        CCLOG("GetParseError %s\n", doc.GetParseError());
    }

    const rapidjson::Value& subJson = DICTOOL->getSubDictionary_json(doc, NODE);
    return loadNode(subJson);
}

cocos2d::Node* NodeCache::loadNode(const rapidjson::Value& json)
{
    cocos2d::Node* node = nullptr;
    std::string nodeType = DICTOOL->getStringValue_json(json, CLASSNAME);

    NodeCreateFunc func = _funcs.at(nodeType);
    if (func != nullptr)
    {
        const rapidjson::Value& options = DICTOOL->getSubDictionary_json(json, OPTIONS);
        node = func(options);
    }
    
    if(node)
    {
        int tag = DICTOOL->getIntValue_json(json, ACTION_TAG);
        node->setTag(tag);
        
        int length = DICTOOL->getArrayCount_json(json, CHILDREN, 0);
        for (int i = 0; i<length; i++)
        {
            const rapidjson::Value &dic = DICTOOL->getSubDictionary_json(json, CHILDREN, i);
            cocos2d::Node* child = loadNode(dic);
            if (child) {
                node->addChild(child);
                const rapidjson::Value& options = DICTOOL->getSubDictionary_json(dic, OPTIONS);
                locateNodeWithMulresPosition(child, options);
            }
        }
    }
    else
    {
        CCLOG("Not supported NodeType: %s", nodeType.c_str());
    }
    
    return node;
}

void NodeCache::initNode(cocos2d::Node* node, const rapidjson::Value& json)
{
    float width         = DICTOOL->getFloatValue_json(json, WIDTH);
    float height        = DICTOOL->getFloatValue_json(json, HEIGHT);
    float x             = DICTOOL->getFloatValue_json(json, X);
    float y             = DICTOOL->getFloatValue_json(json, Y);
    float scalex        = DICTOOL->getFloatValue_json(json, SCALE_X, 1);
    float scaley        = DICTOOL->getFloatValue_json(json, SCALE_Y, 1);
    float rotation      = DICTOOL->getFloatValue_json(json, ROTATION);
    float rotationSkewX = DICTOOL->getFloatValue_json(json, ROTATION_SKEW_X);
    float rotationSkewY = DICTOOL->getFloatValue_json(json, ROTATION_SKEW_Y);
    float skewx         = DICTOOL->getFloatValue_json(json, SKEW_X);
    float skewy         = DICTOOL->getFloatValue_json(json, SKEW_Y);
    float anchorx       = DICTOOL->getFloatValue_json(json, ANCHOR_X, 0.5f);
    float anchory       = DICTOOL->getFloatValue_json(json, ANCHOR_Y, 0.5f);
    GLubyte alpha       = (GLubyte)DICTOOL->getIntValue_json(json, ALPHA, 255);
    GLubyte red         = (GLubyte)DICTOOL->getIntValue_json(json, RED, 255);
    GLubyte green       = (GLubyte)DICTOOL->getIntValue_json(json, GREEN, 255);
    GLubyte blue        = (GLubyte)DICTOOL->getIntValue_json(json, BLUE, 255);

    
    node->setContentSize(Size(width, height));
    node->setPosition(x, y);
    node->setScaleX(scalex);
    node->setScaleY(scaley);
    node->setRotation(rotation);
    node->setRotationSkewX(rotationSkewX);
    node->setRotationSkewY(rotationSkewY);
    node->setSkewX(skewx);
    node->setSkewY(skewy);
    node->setAnchorPoint(Vec2(anchorx, anchory));
    node->setOpacity(alpha); node->setCascadeOpacityEnabled(true);
    node->setColor(Color3B(red, green, blue));
}
    
void NodeCache::locateNodeWithMulresPosition(cocos2d::Node *node, const rapidjson::Value &json)
{
    const rapidjson::Value& mulInfo = DICTOOL->getSubDictionary_json(json, MULRESPOSITION);
    int positionType = DICTOOL->getIntValue_json(mulInfo, POSITIONTYPE);
    
    Vec2 absPos;

    switch (positionType)
    {
        case 0: //absolute
        {
            const rapidjson::Value& position = DICTOOL->getSubDictionary_json(mulInfo, MUL_POSITION);
            float x = DICTOOL->getFloatValue_json(position, MUL_POSITIONX);
            float y = DICTOOL->getFloatValue_json(position, MUL_POSITIONY);
            node->setPosition(Vec2(x, y));
            break;
        }
        case 1: //relative
        {
            Node* parent = node->getParent();
            if (!parent)
            {
                CCLOG("Cannot do layout because Object has no parent!");
                return;
            }
            
            Size layoutSize = parent->getContentSize();
            Size cs = node->getContentSize();
            Vec2 ap = node->getAnchorPoint();
            float finalPosX = 0.0f;
            float finalPosY = 0.0f;
            cocos2d::ui::RelativeLayoutParameter::RelativeAlign align = (cocos2d::ui::RelativeLayoutParameter::RelativeAlign)DICTOOL->getIntValue_json(mulInfo, MUL_RELATIVEALIGN);
            const rapidjson::Value& marginDic = DICTOOL->getSubDictionary_json(mulInfo, MUL_MARGIN);
            cocos2d::ui::Margin mg = cocos2d::ui::Margin(DICTOOL->getFloatValue_json(marginDic, MUL_MARGIN_LEFT),
                                                         DICTOOL->getFloatValue_json(marginDic, MUL_MARGIN_TOP),
                                                         DICTOOL->getFloatValue_json(marginDic, MUL_MARGIN_RIGHT),
                                                         DICTOOL->getFloatValue_json(marginDic, MUL_MARGIN_BOTTOM));
            switch (align)
            {
                case cocos2d::ui::RelativeLayoutParameter::RelativeAlign::NONE:
                case cocos2d::ui::RelativeLayoutParameter::RelativeAlign::PARENT_TOP_LEFT:
                    finalPosX = ap.x * cs.width;
                    finalPosY = layoutSize.height - ((1.0f - ap.y) * cs.height);
                    finalPosX += mg.left;
                    finalPosY -= mg.top;
                    break;
                case cocos2d::ui::RelativeLayoutParameter::RelativeAlign::PARENT_TOP_CENTER_HORIZONTAL:
                    finalPosX = layoutSize.width * 0.5f - cs.width * (0.5f - ap.x);
                    finalPosY = layoutSize.height - ((1.0f - ap.y) * cs.height);
                    finalPosY -= mg.top;
                    break;
                case cocos2d::ui::RelativeLayoutParameter::RelativeAlign::PARENT_TOP_RIGHT:
                    finalPosX = layoutSize.width - ((1.0f - ap.x) * cs.width);
                    finalPosY = layoutSize.height - ((1.0f - ap.y) * cs.height);
                    finalPosX -= mg.right;
                    finalPosY -= mg.top;
                    break;
                case cocos2d::ui::RelativeLayoutParameter::RelativeAlign::PARENT_LEFT_CENTER_VERTICAL:
                    finalPosX = ap.x * cs.width;
                    finalPosY = layoutSize.height * 0.5f - cs.height * (0.5f - ap.y);
                    finalPosX += mg.left;
                    break;
                case cocos2d::ui::RelativeLayoutParameter::RelativeAlign::CENTER_IN_PARENT:
                    finalPosX = layoutSize.width * 0.5f - cs.width * (0.5f - ap.x);
                    finalPosY = layoutSize.height * 0.5f - cs.height * (0.5f - ap.y);
                    break;
                case cocos2d::ui::RelativeLayoutParameter::RelativeAlign::PARENT_RIGHT_CENTER_VERTICAL:
                    finalPosX = layoutSize.width - ((1.0f - ap.x) * cs.width);
                    finalPosY = layoutSize.height * 0.5f - cs.height * (0.5f - ap.y);
                    finalPosX -= mg.right;
                    break;
                case cocos2d::ui::RelativeLayoutParameter::RelativeAlign::PARENT_LEFT_BOTTOM:
                    finalPosX = ap.x * cs.width;
                    finalPosY = ap.y * cs.height;
                    finalPosX += mg.left;
                    finalPosY += mg.bottom;
                    break;
                case cocos2d::ui::RelativeLayoutParameter::RelativeAlign::PARENT_BOTTOM_CENTER_HORIZONTAL:
                    finalPosX = layoutSize.width * 0.5f - cs.width * (0.5f - ap.x);
                    finalPosY = ap.y * cs.height;
                    finalPosY += mg.bottom;
                    break;
                case cocos2d::ui::RelativeLayoutParameter::RelativeAlign::PARENT_RIGHT_BOTTOM:
                    finalPosX = layoutSize.width - ((1.0f - ap.x) * cs.width);
                    finalPosY = ap.y * cs.height;
                    finalPosX -= mg.right;
                    finalPosY += mg.bottom;
                    break;
                default:
                    break;
            }
            node->setPosition(Vec2(finalPosX, finalPosY));
            break;
        }
        case 2: //percentage
        {
            Node* parent = node->getParent();
            if (!parent)
            {
                CCLOG("Cannot do layout because Object has no parent!");
                return;
            }
            const rapidjson::Value& percentage = DICTOOL->getSubDictionary_json(mulInfo, MUL_POSITIONPERCENTAGE);
            float percentageX = DICTOOL->getFloatValue_json(percentage, MUL_POSITIONPERCENTAGEX);
            float percentageY = DICTOOL->getFloatValue_json(percentage, MUL_POSITIONPERCENTAGEY);
            Size pSize = parent->getContentSize();
            node->setPosition(Vec2(pSize.width * percentageX, pSize.height * percentageY));
            break;
        }
        default:
            break;
    }
//    node->setPosition(absPos);
}

Node* NodeCache::loadSimpleNode(const rapidjson::Value& json)
{
    Node* node = Node::create();
    initNode(node, json);

    return node;
}

cocos2d::Node* NodeCache::loadSubGraph(const rapidjson::Value& json)
{
    const char* filePath = DICTOOL->getStringValue_json(json, FILE_PATH);

    Node* node = nullptr;
    if (filePath && strcmp("", filePath) != 0)
    {
        node = createNode(filePath);
    }
    else
    {
        node = Node::create();
    }

    initNode(node, json);

    return node;
}

Node* NodeCache::loadSprite(const rapidjson::Value& json)
{
    const char* filePath = DICTOOL->getStringValue_json(json, FILE_PATH);
    if (strcmp("", filePath) == 0)
    {
        return nullptr;
    }

    Sprite *sprite = nullptr;
    SpriteFrame* spriteFrame = SpriteFrameCache::getInstance()->getSpriteFrameByName(filePath);
    if(!spriteFrame)
    {
        sprite = Sprite::create(filePath);
    }
    else
    {
        sprite = Sprite::createWithSpriteFrame(spriteFrame);
    }

    if(!sprite)
    {
        sprite = CCSprite::create();
        CCLOG("filePath is empty. Create a sprite with no texture");
    }

    initNode(sprite, json);

    return sprite;
}

Node* NodeCache::loadParticle(const rapidjson::Value& json)
{
    const char* filePath = DICTOOL->getStringValue_json(json, PLIST_FILE);
    int num = DICTOOL->getIntValue_json(json, PARTICLE_NUM);

    ParticleSystemQuad* particle = ParticleSystemQuad::create(filePath);
    particle->setTotalParticles(num);

    initNode(particle, json);

    return particle;
}

cocos2d::Node* NodeCache::loadWidget(const rapidjson::Value& json)
{
    const char* classname = DICTOOL->getStringValue_json(json, CLASSNAME);

    std::string readerName = classname;
    readerName.append("Reader");

    Widget*               widget = ObjectFactory::getInstance()->createGUI(classname);
    WidgetReaderProtocol* reader = ObjectFactory::getInstance()->createWidgetReaderProtocol(readerName);

    _guiReader->setPropsForAllWidgetFromJsonDictionary(reader, widget, json);

    return widget;
}

}
}
