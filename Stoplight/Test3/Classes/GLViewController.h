//
//  GLViewController.h
//  Test3
//
//  Created by Joseph on 6/15/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLView.h"

@interface GLViewController : UIViewController <GLViewDelegate>
{
@private
    
    GLfloat angle;
    NSMutableArray *vertices;
    Boolean wasTouched;
    GLfloat touch_x;
    GLfloat touch_y;
    quad myQuads[3];
    Boolean initialized;
    IBOutlet UITextField *_lblPoints;
    GLfloat size;
    GLfloat MOVE_INCREMENT;
    Boolean autoMode;    
    GLuint texture[2];
    int arrLen;
    GLfloat texCoords[8];
    int timer;
    bool timerReset;
    int redLength, yellowLength, greenLength;
    int timerLimit;
    int quadTouchIndex;
    int touchTimer;
    Boolean controlToggle;
    Boolean blinkingRed;
    Boolean blinkingYellow;
    int blinkingRedTimer;
    int blinkingYellowTimer;
}
@end;

