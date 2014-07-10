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

#ifndef __CCFRAME_H__
#define __CCFRAME_H__

#include "CCTimeLine.h"

namespace cocostudio {
namespace timeline{


class Frame : public cocos2d::Object
{
public:

    inline void setFrameIndex(unsigned int frameIndex) { _frameIndex = frameIndex; }
    inline unsigned int getFrameIndex()const { return _frameIndex; }

    inline void setNode(cocos2d::Node* node) { _node = node; }
    inline cocos2d::Node* getTimelineNode() const { return _node; }

    inline void setTween(bool tween) { _tween = tween; }
    inline bool isTween()const { return _tween; }

    virtual void onEnter(Frame *nextFrame) = 0;
    virtual void apply(float percent) {}

    virtual Frame* clone() = 0;
protected:
    Frame();
    virtual ~Frame();

    void cloneProperty(Frame* frame);
protected:
    friend class Timeline;

    unsigned int    _frameIndex;
    bool            _tween;

    cocos2d::Node*  _node;
};


class VisibleFrame : public Frame
{
public:
    static VisibleFrame* create();

    VisibleFrame();

    virtual void onEnter(Frame *nextFrame) override;
    virtual Frame* clone() override;

    inline void setVisible(bool visible) { _visible = visible;}
    inline bool isVisible() const { return _visible; }

protected:
    bool _visible;
};


class RotationFrame : public Frame
{
public:
    static RotationFrame* create();

    RotationFrame();

    virtual void onEnter(Frame *nextFrame) override;
    virtual void apply(float percent) override;
    virtual Frame* clone() override;

    inline void  setRotation(float rotation) { _rotation = rotation; }
    inline float getRotation() const { return _rotation; }

protected:
    float _rotation;
    float _betwennRotation;
};

class SkewFrame : public Frame
{
public:
    static SkewFrame* create();

    SkewFrame();

    virtual void onEnter(Frame *nextFrame) override;
    virtual void apply(float percent) override;
    virtual Frame* clone() override;

    inline void  setSkewX(float skewx) { _skewX = skewx; }
    inline float getSkewX() const { return _skewX; }

    inline void  setSkewY(float skewy) { _skewY = skewy; }
    inline float getSkewY() const { return _skewY; }

protected:
    float _skewX;
    float _skewY;
    float _betweenSkewX;
    float _betweenSkewY;
};


class RotationSkewFrame : public SkewFrame
{
public:
    static RotationSkewFrame* create();

    RotationSkewFrame();

    virtual void onEnter(Frame *nextFrame) override;
    virtual void apply(float percent) override;
    virtual Frame* clone() override;
};


class PositionFrame : public Frame
{
public:
    static PositionFrame* create();

    PositionFrame();

    virtual void onEnter(Frame *nextFrame) override;
    virtual void apply(float percent) override;
    virtual Frame* clone() override;

    inline void setPosition(const cocos2d::Point& position) { _position = position; }
    inline cocos2d::Point getPosition() const { return _position; }

protected:
    cocos2d::Point _position;
    float _betweenX;
    float _betweenY;
};


class ScaleFrame : public Frame
{
public:
    static ScaleFrame* create();

    ScaleFrame();

    virtual void onEnter(Frame *nextFrame) override;
    virtual void apply(float percent) override;
    virtual Frame* clone() override;

    inline void  setScale(float scale) { _scaleX = scale; _scaleY = scale; }

    inline void  setScaleX(float scaleX) { _scaleX = scaleX; }
    inline float getScaleX() const { return _scaleX; }

    inline void  setScaleY(float scaleY) { _scaleY = scaleY;}
    inline float getScaleY() const { return _scaleY; }

protected:
    float _scaleX;
    float _scaleY;
    float _betweenScaleX;
    float _betweenScaleY;
};


class AnchorPointFrame : public Frame
{
public:
    static AnchorPointFrame* create();

    AnchorPointFrame();

    virtual void onEnter(Frame *nextFrame) override;
    virtual Frame* clone() override;

    inline void setAnchorPoint(const cocos2d::Point& point) { _anchorPoint = point; }
    inline cocos2d::Point getAnchorPoint() const { return _anchorPoint; }

protected:
    cocos2d::Point _anchorPoint;
};



enum InnerActionType
{
    LoopAction,
    NoLoopAction,
    SingleFrame
};

class InnerActionFrame : public Frame
{
public:
    static InnerActionFrame* create();
    InnerActionFrame();

    virtual void onEnter(Frame *nextFrame) override;
    virtual Frame* clone() override;

    inline void setInnerActionType(InnerActionType type) { _innerActionType = type; }
    inline InnerActionType getInnerActionType() const { return _innerActionType; }

    inline void setStartFrameIndex(int frameIndex) { _startFrameIndex = frameIndex; }
    inline int  getStartFrameIndex() const { return _startFrameIndex; }

protected:
    InnerActionType _innerActionType;
    int _startFrameIndex;
};


class ColorFrame : public Frame
{
public:
    static ColorFrame* create();
    ColorFrame();

    virtual void onEnter(Frame *nextFrame) override;
    virtual void apply(float percent) override;
    virtual Frame* clone() override;

    inline void    setAlpha(GLubyte alpha) { _alpha = alpha; }
    inline GLubyte getAlpha() const { return _alpha; }

    inline void    setColor(const cocos2d::Color3B& color) { _color = color; }
    inline cocos2d::Color3B getColor() const { return _color; }

protected:
    GLubyte _alpha;
    cocos2d::Color3B _color;

    int _betweenAlpha;
    int _betweenRed;
    int _betweenGreen;
    int _betweenBlue;
};


}
}


#endif /*__CCFRAME_H__*/
