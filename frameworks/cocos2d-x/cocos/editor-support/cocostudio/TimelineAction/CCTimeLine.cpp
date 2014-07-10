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

#include "CCTimeLine.h"
#include "CCFrame.h"

using namespace cocos2d;

namespace cocostudio {
namespace timeline{

Timeline* Timeline::create()
{
    Timeline* object = new Timeline();
    if (object)
    {
        object->autorelease();
        return object;
    }
    CC_SAFE_DELETE(object);
    return nullptr;
}

Timeline::Timeline()
    : _currentKeyFrame(nullptr)
    , _currentKeyFrameIndex(0)
    , _fromIndex(0)
    , _toIndex(0)
    , _betweenDuration(0)
    , _actionTag(0)
    , _node(nullptr)
{
}

Timeline::~Timeline()
{
}

void Timeline::gotoFrame(int frameIndex)
{
    updateCurrentKeyFrame(frameIndex);

    if (_currentKeyFrame)
    {
        float currentPercent = _betweenDuration == 0 ? 0 : (frameIndex - _currentKeyFrameIndex) / (float)_betweenDuration;
        _currentKeyFrame->apply(currentPercent);
    }
}

Timeline* Timeline::clone()
{
    Timeline* timeline = Timeline::create();
    timeline->_actionTag = _actionTag;

    for (auto frame : _frames)
    {
        Frame* newFrame = frame->clone();
        timeline->getFrames().pushBack(newFrame);
    }

    return timeline;
}

void Timeline::setNode(cocos2d::Node* node)
{
    for (auto frame : _frames)
    {
        frame->setNode(node);
    }
}

cocos2d::Node* Timeline::getNode()
{
    return _node;
}

void Timeline::updateCurrentKeyFrame(int frameIndex)
{
    //! If play to current frame's front or back, then find current frame again
    if (frameIndex < _currentKeyFrameIndex || frameIndex >= _currentKeyFrameIndex + _betweenDuration)
    {
        Frame *from = nullptr;
        Frame *to = nullptr;

        do 
        {
            long length = _frames.size();

            if (frameIndex < _frames.at(0)->getFrameIndex())
            {
                from = to = _frames.at(0);
                break;
            }
            else if(frameIndex >= _frames.at(length - 1)->getFrameIndex())
            {
                from = to = _frames.at(length - 1);
                _currentKeyFrameIndex = 0;
                _betweenDuration = 0;
                break;
            }

            do
            {
                _fromIndex = _toIndex;
                from = _frames.at(_fromIndex);
                _currentKeyFrameIndex  = from->getFrameIndex();

                _toIndex = _fromIndex + 1;
                if (_toIndex >= length)
                {
                    _toIndex = 0;
                }

                to = _frames.at(_toIndex);

                if (frameIndex == from->getFrameIndex())
                {
                    break;
                }
            }
            while (frameIndex < from->getFrameIndex() || frameIndex >= to->getFrameIndex());

            _betweenDuration = to->getFrameIndex() - from->getFrameIndex();

        } while (0);

        _currentKeyFrame = from;
        _currentKeyFrame->onEnter(to);
    }
}

}
}
