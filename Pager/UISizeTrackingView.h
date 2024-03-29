//
//  UISizeTrackingView.h
//  Pager
//
//  Created by Test on 01/03/2024.
//

#ifndef UISizeTrackingView_h
#define UISizeTrackingView_h

/* Generated by RuntimeBrowser
   Image: /System/Library/Frameworks/UIKit.framework/UIKit
 */

@interface _UISizeTrackingView : UIView <_UIRemoteViewFocusProxy, _UIScrollToTopView> {
    struct CGRect {
        struct CGPoint {
            double x;
            double y;
        } origin;
        struct CGSize {
            double width;
            double height;
        } size;
    }  _formerTextEffectsContentFrame;
    bool  _hasIntrinsicContentSize;
    struct CGSize {
        double width;
        double height;
    }  _intrinsicContentSize;
    _UIRemoteViewController * _remoteViewController;
    id  _textEffectsOperatorProxy;
    id  _viewControllerOperatorProxy;
}

@property (readonly, copy) NSString *debugDescription;
@property (readonly, copy) NSString *description;
@property (readonly) unsigned long long hash;
@property (nonatomic, readonly) _UIRemoteViewController *remoteViewController;
@property (readonly) Class superclass;

+ (id)viewWithRemoteViewController:(id)arg1 viewControllerOperatorProxy:(id)arg2 textEffectsOperatorProxy:(id)arg3;

- (void).cxx_destruct;
- (id)_childFocusRegions;
- (id)_childFocusRegionsInRect:(struct CGRect { struct CGPoint { double x_1_1_1; double x_1_1_2; } x1; struct CGSize { double x_2_1_1; double x_2_1_2; } x2; })arg1;
- (void)_didMoveFromWindow:(id)arg1 toWindow:(id)arg2;
- (void)_geometryChanges:(id)arg1 forAncestor:(id)arg2;
- (long long)_interfaceOrientationForScene:(id)arg1;
- (struct CGSize { double x1; double x2; })_intrinsicSizeWithinSize:(struct CGSize { double x1; double x2; })arg1;
- (bool)_needsTextEffectsUpdateToFrame:(struct CGRect { struct CGPoint { double x_1_1_1; double x_1_1_2; } x1; struct CGSize { double x_2_1_1; double x_2_1_2; } x2; })arg1;
- (void)_scrollToTopFromTouchAtScreenLocation:(struct CGPoint { double x1; double x2; })arg1 resultHandler:(id /* block */)arg2;
- (void)_updateSceneGeometries:(id)arg1 forOrientation:(long long)arg2;
- (void)_updateTextEffectsGeometries:(struct CGRect { struct CGPoint { double x_1_1_1; double x_1_1_2; } x1; struct CGSize { double x_2_1_1; double x_2_1_2; } x2; })arg1;
- (void)_updateTextEffectsGeometriesImmediately;
- (bool)canBecomeFocused;
- (void)dealloc;
- (bool)isScrollEnabled;
- (id)remoteViewController;
- (void)updateIntrinsicContentSize:(struct CGSize { double x1; double x2; })arg1 {
    UISc
}

@end

#endif /* UISizeTrackingView_h */
