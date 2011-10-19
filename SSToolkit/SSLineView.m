//
//  SSLineView.m
//  SSToolkit
//
//  Created by Sam Soffes on 4/12/10.
//  Copyright 2010-2011 Sam Soffes. All rights reserved.
//

#import "SSLineView.h"

@interface SSLineView ()
- (void)_initialize;
@end

@implementation SSLineView

@synthesize lineColor = _lineColor;
@synthesize insetColor = _insetColor;
@synthesize dashPhase = _dashPhase;
@synthesize dashLengths = _dashLengths;
@synthesize lineDirection = _lineDirection;
@synthesize lineWidth = _lineWidth;

- (void)setLineColor:(UIColor *)lineColor {
	[lineColor retain];
	[_lineColor release];
	_lineColor = lineColor;
	
	[self setNeedsDisplay];
}


- (void)setInsetColor:(UIColor *)insetColor {
	[insetColor retain];
	[_insetColor release];
	_insetColor = insetColor;
	
	[self setNeedsDisplay];
}


- (void)setDashPhase:(CGFloat)dashPhase {
	_dashPhase = dashPhase;
	
	[self setNeedsDisplay];
}


- (void)setDashLengths:(NSArray *)dashLengths {
	[_dashLengths autorelease];
	_dashLengths = [dashLengths copy];
	
	[self setNeedsDisplay];
}

- (void)setLineDirection:(SSLineDirection)lineDirection
{
    _lineDirection = lineDirection;
    
    [self setNeedsDisplay];
}

- (void)setLineWidth:(CGFloat)lineWidth
{
    if( lineWidth < 0.0 )
    {
        lineWidth = 0.0;
    }
    _lineWidth = lineWidth;
    
    [self setNeedsDisplay];
}

#pragma mark - NSObject

- (void)dealloc {
	[_lineColor release];
	[_insetColor release];
	[_dashLengths release];
	[super dealloc];
}


#pragma mark - UIView

- (id)initWithCoder:(NSCoder *)aDecoder {
	if ((self = [super initWithCoder:aDecoder])) {
		[self _initialize];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
		[self _initialize];
	}
	return self;
}


- (void)drawRect:(CGRect)rect {	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextClipToRect(context, rect);
    CGFloat halfLineWidth = (_insetColor != nil) ? _lineWidth / 2 : _lineWidth;
	CGContextSetLineWidth(context, halfLineWidth);
	
	if (_dashLengths) {
		NSUInteger dashLengthsCount = [_dashLengths count];
		CGFloat *lengths = (CGFloat *)malloc(sizeof(CGFloat) * dashLengthsCount);
		for (NSUInteger i = 0; i < dashLengthsCount; i++) {
			lengths[i] = [[_dashLengths objectAtIndex:i] floatValue];
		}
		
		CGContextSetLineDash(context, _dashPhase, lengths, dashLengthsCount);
		
		free(lengths);
	}

	// Inset
	if (_insetColor) {
		CGContextSetStrokeColorWithColor(context, _insetColor.CGColor);
        if( _lineDirection == SSLineDirectionHorizontal )
        {
            CGContextMoveToPoint(context, 0.0f, halfLineWidth);
            CGContextAddLineToPoint(context, rect.size.width, halfLineWidth);
        }
        else
        {
            CGContextMoveToPoint(context, halfLineWidth, 0.0f);
            CGContextAddLineToPoint(context, halfLineWidth, rect.size.height);
        }
		CGContextStrokePath(context);
	}
	
	// Top border
	CGContextSetStrokeColorWithColor(context, _lineColor.CGColor);
    CGContextMoveToPoint(context, 0.0f, 0.0f);
    if( _lineDirection == SSLineDirectionHorizontal )
    {
        CGContextAddLineToPoint(context, rect.size.width, 0.0f);
    }
    else
    {
        CGContextAddLineToPoint(context, 0.0f, rect.size.height);
    }
	CGContextStrokePath(context);
}


#pragma mark - Private

- (void)_initialize {
	self.backgroundColor = [UIColor clearColor];
	self.opaque = NO;
	self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	
	self.lineColor = [UIColor grayColor];
	self.insetColor = [UIColor colorWithWhite:1.0f alpha:0.5f];
    self.lineDirection = SSLineDirectionHorizontal;
    self.lineWidth = 2.0f;
}

@end
