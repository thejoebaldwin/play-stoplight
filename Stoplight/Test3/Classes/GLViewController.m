//
//  GLViewController.m
//  Test3
//
//  Created by Joseph on 6/15/11.
//  Copyright Humboldt Technology Group, LLC 2011. All rights reserved.
//

#import "GLViewController.h"
#import "ConstantsAndMacros.h"
#import "OpenGLCommon.h"
#import "Test3AppDelegate.h"
@implementation GLViewController

-(void) updateQuad: (quad*) theQuad
{   
    //if there is a velocity, this will update the movement on the quad
    theQuad->move_x = theQuad->move_x + MOVE_INCREMENT * theQuad->velocity_x;
    theQuad->move_y = theQuad->move_y + MOVE_INCREMENT * theQuad->velocity_y;
}

-(void) initQuad: (quad*) theQuad
{
    GLfloat z = theQuad->z;
    GLfloat square_vertex[] = {
        // FRONT
        0.0 + theQuad->x,  0.0 + theQuad->y, z,
        theQuad->x + theQuad->width, 0.0 + theQuad->y, z,
        0.0 + theQuad->x,  theQuad->y + theQuad->height, z,
        theQuad->x + theQuad->width, theQuad->y + theQuad->height, z
    };

    theQuad->left = theQuad->x;
    theQuad->right = theQuad->x + theQuad->width;
    theQuad->top = theQuad->y + theQuad->height;
    theQuad->bottom = theQuad->y;
    theQuad->isVisible = true;
    for (int i =0; i < 12;i++)
    {
        theQuad->vertices[i] = square_vertex[i];    
    }
    //the following sets initial, random velocities
    
    theQuad->velocity_x =  0;
    theQuad->velocity_y =  0;
}


-(Boolean) isCollision:(quad *)theQuad
{
    //screen dimension from touch is 320 x 480
    Boolean wasCollision = false;
    GLfloat temp_x = touch_x;
    GLfloat temp_y = touch_y;
    if ((temp_x >= theQuad->left + theQuad->move_x) && (temp_x <= theQuad->right +theQuad->move_x))
     {
         if (-temp_y <= theQuad->top - theQuad->move_y && -temp_y >= theQuad->bottom - theQuad->move_y)
         {
             if (theQuad->is_selected)
             {
  //               theQuad->is_selected = false;
             }
             else
             {
//                 theQuad->is_selected = true;
             }
             
               //theQuad->is_selected = true;
             wasCollision = true;
        }
     }
           
    //check if it hit border, if so reverse velocity
    return wasCollision;
}


-(void) checkEdgeCollision:(quad *) theQuad
{
    GLfloat x_bound = 13.0;
    GLfloat y_bound = 18.0;
      if (theQuad->x + theQuad->move_x >= x_bound || theQuad->x + theQuad->move_x <= -x_bound)
    {
        theQuad->velocity_x = theQuad->velocity_x * -1.0;
        
    }
    
    if (theQuad->y + theQuad->move_y >= y_bound || theQuad->y + theQuad->move_y <= -y_bound)
    {
        theQuad->velocity_y = theQuad->velocity_y * -1.0;
    }

}

-(void) drawSquare:(quad*) theQuad
{       
    Boolean tempBool = false;
    if (theQuad->move_x != 0 && theQuad->move_y != 0)
    {
            glTranslatef(theQuad->move_x, -(theQuad->move_y), 0.0);
            tempBool = true;
    }
    if (theQuad->is_selected)
    {
     glBindTexture(GL_TEXTURE_2D, texture[0]);
    }   
    else
    {
     glBindTexture(GL_TEXTURE_2D, texture[1]);
    }  
    glColor4f(theQuad->color[0], theQuad->color[1], theQuad->color[2], theQuad->color[3]);

    glVertexPointer(3, GL_FLOAT, 0, &(theQuad->vertices));
    glTexCoordPointer(2, GL_FLOAT, 0, texCoords);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    if (tempBool)
    {
     glTranslatef(-(theQuad->move_x), (theQuad->move_y), 0.0);
    }
}
 
-(void) initVertices
{
    GLfloat width = 15.5;

    GLfloat x = -width / 2;
    GLfloat y_offset = width - 3;
    GLfloat y = y_offset - width / 2;
    
    quad redLight;
    redLight.color[0] = 1.0;
    redLight.color[1] = 0.0;
    redLight.color[2] = 0.0;
    redLight.color[3] = 1.0;
    redLight.x = x;
    redLight.y = y;
    redLight.z = 0;
    redLight.width = width;
    redLight.height = width;
    redLight.move_x = 0;
    redLight.move_y = 0;
    redLight.is_selected = false;
    [self initQuad: &redLight];
    myQuads[0] = redLight;     

    quad yellowLight;
    yellowLight.color[0] = 1.0;
    yellowLight.color[1] = 1.0;
    yellowLight.color[2] = 0.0;
    yellowLight.color[3] = 1.0;
    yellowLight.x = x;
    yellowLight.y = y - y_offset * 1;
    yellowLight.z = 0;
    yellowLight.width = width;
    yellowLight.height = width;
    yellowLight.move_x = 0;
    yellowLight.move_y = 0;
    yellowLight.is_selected = false;
    [self initQuad: &yellowLight];
    myQuads[1] = yellowLight;
    
    quad greenLight;
    greenLight.color[0] = 0.0;
    greenLight.color[1] = 1.0;
    greenLight.color[2] = 0.0;
    greenLight.color[3] = 1.0;
    greenLight.x = x;
    greenLight.y = y - y_offset * 2;
    greenLight.z = 0;
    greenLight.width = width;
    greenLight.height = width;
    greenLight.move_x = 0;
    greenLight.move_y = 0;
    greenLight.is_selected = false;
    [self initQuad: &greenLight];
    myQuads[2] = greenLight;
    
    initialized = true;
 }

- (void) update
{
    //do all updates here
    Test3AppDelegate *appDelegate = (Test3AppDelegate *) [[UIApplication sharedApplication] delegate];

    //loop through and see if anything was touched
    for (int i =0; i < arrLen ;i++)
    {
        [self updateQuad: &(myQuads[i])];  
        if (wasTouched)
        {
           if ([self isCollision:&(myQuads[i])])
           {
               blinkingRed = false;
               blinkingYellow = false;
               //if already selected, then turn on blinking for red and yellow
               if (myQuads[i].is_selected)
               {
                   if (i == 0)
                   {
                       blinkingRed = true;
                   }
                   else if (i == 1)
                   {
                       blinkingYellow = true;

                   }
               }
               myQuads[i].is_selected = true;
               quadTouchIndex = i;
           };    
        }
    }
    //if there was a touch event and nothing was selected
    //then show interface
    if (wasTouched && quadTouchIndex == -1)
    {
        if (controlToggle) 
        {
                    controlToggle = false;
           
        
        }
        else
        {
            //turn controls on
            controlToggle = true;
        }
    }

    
    //check if any of the slider values changed
    if (controlToggle)
    {
        if (appDelegate.lblAuto.hidden)
        {
            appDelegate.switchTimer.hidden = false;
            appDelegate.lblAuto.hidden = false;
            appDelegate.lblFast.hidden = false;
            appDelegate.lblSlow.hidden = false;
            appDelegate.sliderRed.hidden = false;
            appDelegate.sliderYellow.hidden = false;
            appDelegate.sliderGreen.hidden = false;
            appDelegate.lblRed.hidden = false;
            appDelegate.lblYellow.hidden = false;
            appDelegate.lblGreen.hidden = false;
        }
    }
    else
    {
        if (!appDelegate.lblAuto.hidden)
        {
            //turn controls off
            //check if anything changed here
             [self checkLightLengths];
            appDelegate.switchTimer.hidden = true;
            appDelegate.lblAuto.hidden = true;
            appDelegate.lblFast.hidden = true;
            appDelegate.lblSlow.hidden = true;
            appDelegate.sliderRed.hidden = true;
            appDelegate.sliderYellow.hidden = true;
            appDelegate.sliderGreen.hidden = true;
            appDelegate.lblRed.hidden = true;
            appDelegate.lblYellow.hidden = true;
            appDelegate.lblGreen.hidden = true;
            
        }
    }

    angle = angle + 0.1f;
    if (angle > 360)
    {
        angle=1;
    }
  
    if (appDelegate.switchTimer.on == YES)
    {
             autoMode = true;
    }
    else
    {
        autoMode = false;
    }
    
    wasTouched = false;

    
    [self lightController];
    
    
    quadTouchIndex = -1;
    wasTouched = false;
    
    //only increment timer if timer switch is on
    if (appDelegate.switchTimer.on == YES)
    {
    timer = timer + 1;
    }

    if (timerReset) 
    {
        timerReset = false;
        timer = 0;
    }


      }

-(void) lightController
{
    Test3AppDelegate *appDelegate = (Test3AppDelegate *) [[UIApplication sharedApplication] delegate];
    int blinkRate = 50;

    
    //this has to go in a function
    //if timer switch is off and a shape was touched
    if (quadTouchIndex > -1 && appDelegate.switchTimer.on == NO)
    {
        if (quadTouchIndex == 0)
        {
            //red light clicked
            timer = yellowLength + 1;   
            myQuads[1].is_selected = false;
            myQuads[2].is_selected = false;
        }
        else if (quadTouchIndex == 1)
        {
            //yellow light clicked
            timer = greenLength + 1;
            myQuads[0].is_selected = false;
            myQuads[2].is_selected = false;
            
        }
        else if (quadTouchIndex == 2)
        {
            //green light clicked
            timer = 0;
            myQuads[0].is_selected = false;
            myQuads[1].is_selected = false;
            timerReset = true;
        }
    }
    
    if (appDelegate.switchTimer.on == YES)
    {
        if (timer >= 0 && timer < greenLength)
        {
            myQuads[0].is_selected = false;
            myQuads[1].is_selected = false;
            myQuads[2].is_selected = true;
        }
        else if (timer >= greenLength && timer < yellowLength + greenLength)
        {
            myQuads[0].is_selected = false;
            myQuads[1].is_selected = true;
            myQuads[2].is_selected = false;
        }
        else if (timer >= yellowLength + greenLength && timer <= timerLimit)
        {
            myQuads[0].is_selected = true;
            myQuads[1].is_selected = false;
            myQuads[2].is_selected = false;        
        }
        else
        {
            timerReset = true;
        }
    }
    else
    {
        if (blinkingRed)
        {
            blinkingRedTimer++;
            if (blinkingRedTimer >= 300) blinkingRedTimer = 0;
            if (blinkingRedTimer % blinkRate == 0)
            {
                if (myQuads[0].is_selected)
                {
                    myQuads[0].is_selected = false;
                }
                else
                {
                    myQuads[0].is_selected = true;
                }
            }
        }
        else if (blinkingYellow)
        {
            blinkingYellowTimer++;
            if (blinkingYellowTimer >= 300) blinkingYellowTimer = 0;
            if (blinkingYellowTimer % blinkRate == 0)
            {
                if (myQuads[1].is_selected)
                {
                    myQuads[1].is_selected = false;
                }
                else
                {
                    myQuads[1].is_selected = true;
                }
            }
            
        }
        
    }
    
}

-(void) initLightLengths
{
    
    
    Test3AppDelegate *appDelegate = (Test3AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
  
      
    if (![defaults valueForKey:@"greenLength"] == nil)
    {
        //load data
        NSString* tempGreen = [defaults stringForKey:@"greenLength"];
        appDelegate.sliderGreen.value = (GLfloat) [tempGreen intValue];
    }
    if (![defaults valueForKey:@"yellowLength"] == nil)
    {
        //load data
        NSString* tempYellow = [defaults stringForKey:@"yellowLength"];
        appDelegate.sliderYellow.value  = (GLfloat) [tempYellow intValue];
    }
    if (![defaults valueForKey:@"redLength"] == nil)
    {
        //load data
        NSString* tempRed = [defaults stringForKey:@"redLength"];
        appDelegate.sliderRed.value  =  (GLfloat) [tempRed intValue];

        
    }
    greenLength =  appDelegate.sliderGreen.value;
    yellowLength =  appDelegate.sliderYellow.value;
    redLength = appDelegate.sliderRed.value;
}

-(void) checkLightLengths
{
    Test3AppDelegate *appDelegate = (Test3AppDelegate *) [[UIApplication sharedApplication] delegate];
    Boolean valuesChanged = false;
    
    if (greenLength != appDelegate.sliderGreen.value) valuesChanged = true;
    greenLength =  appDelegate.sliderGreen.value;
    if (yellowLength !=  appDelegate.sliderYellow.value) valuesChanged = true;
    yellowLength =  appDelegate.sliderYellow.value;
    if (redLength != appDelegate.sliderRed.value) valuesChanged = true;
    redLength = appDelegate.sliderRed.value;
    timerLimit = redLength + yellowLength + greenLength;
    if (valuesChanged) 
    {
        //if something changed then reset lights
        //save data
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        [defaults setObject:[[NSString alloc] initWithFormat:@"%i",(int) greenLength] forKey:@"greenLength"];
        [defaults setObject:[[NSString alloc] initWithFormat:@"%i", (int) yellowLength] forKey:@"yellowLength"];
        [defaults setObject:[[NSString alloc] initWithFormat:@"%i", (int) redLength] forKey:@"redLength"];
        
        
        [defaults synchronize];
        timerReset = true;
    }

}

- (void)drawView:(UIView *)theView
{
    Test3AppDelegate *appDelegate = (Test3AppDelegate *) [[UIApplication sharedApplication] delegate];
    GLfloat sliderVal = appDelegate.sliderScale.value;
    NSString *scale = [[NSString alloc] initWithFormat:@"%f", sliderVal];
    appDelegate.lblSliderValue.Text = scale;

    //start GL
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glLoadIdentity();
    //background color
    glClearColor(0.0, 0.0, 0.0, 0.0);
    glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    glTranslatef(0, 0, - 30);
    
    for (int i =0; i < arrLen ;i++)
    {
        [self drawSquare: &(myQuads[i])];  
    }
    
    //stop gl
    glDisableClientState(GL_VERTEX_ARRAY);    
    glDisableClientState(GL_TEXTURE_COORD_ARRAY);    
    
    //cleanup
    [self update];    
    
}


//********** VIEW DID UNLOAD **********
- (void)viewDidUnload
{
	[super viewDidUnload];
    
	[_lblPoints release];
	_lblPoints = nil;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    wasTouched = true;
    UITouch *theTouch = [touches anyObject];
    GLfloat sliderVal = 0;
    CGPoint currentTouchPosition = [theTouch locationInView: self.view ];
    touch_x = (GLfloat) currentTouchPosition.x;
    touch_y = (GLfloat) currentTouchPosition.y;
    CGRect rect = self.view.bounds; 
    if (sliderVal > 0)
    {
        //center the coordinates
        GLfloat scale = (rect.size.width / rect.size.height) * size * (30 - sliderVal);
        touch_x = touch_x - (rect.size.width / 2);
        touch_y = touch_y - (rect.size.height / 2);
        touch_x = touch_x * scale;
        touch_y = touch_y * scale;
    }
    else if (sliderVal < 0)
    {
        GLfloat scale = (rect.size.width / rect.size.height) * size * (30 - sliderVal);
        touch_x = touch_x - (rect.size.width / 2);
        touch_y = touch_y - (rect.size.height / 2);
        touch_x = touch_x * scale;
        touch_y = touch_y * scale;
    }
    else
    {
        GLfloat scale = (rect.size.width / rect.size.height) * size * (30 - sliderVal);
        touch_x = touch_x - (rect.size.width / 2);
        touch_y = touch_y - (rect.size.height / 2);
        touch_x = touch_x * scale;
        touch_y = touch_y * scale;        
    }
    
    //debug
    //NSString *s = [[NSString alloc] initWithFormat:@"%f,%f", touch_x, touch_y];
    //appDelegate.lblPoints.Text = s;
    wasTouched = true;   
  }


-(void) initialize
{
    //initialize all shapes
    arrLen = (sizeof myQuads / sizeof myQuads[0]);
    
    [self initVertices];
    
    //load textures
    [self loadTextures:[[NSBundle mainBundle  ] pathForResource:@"flare" ofType:@"png"] andIndex:0];
    [self loadTextures:[[NSBundle mainBundle  ] pathForResource:@"off" ofType:@"png"] andIndex: 1];
    
    texCoords[0] =  0.0;
    texCoords[1] =  1.0;
    texCoords[2] =  1.0;
    texCoords[3] =  1.0;
    texCoords[4] =  0.0;
    texCoords[5] =  0.0;
    texCoords[6] =  1.0;
    texCoords[7] =  0.0;
    
    timer = 201;
    timerReset = true;
    timerLimit = 1300;
    touch_x = -1000;
    touch_y = -1000;
    quadTouchIndex = -1;
    autoMode = true;
    
    [self initLightLengths];

}

-(void)setupView:(GLView*)view
{
	//const GLfloat zNear = 0.01, zFar = 1000.0;//, fieldOfView = 45.0; 
	//GLfloat size; 
	//glEnable(GL_DEPTH_TEST);
    glEnable(GL_TEXTURE_2D);
    glEnable(GL_BLEND);
	glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
    glMatrixMode(GL_PROJECTION); 
    //movement speed
	MOVE_INCREMENT = 0.03;
    CGRect rect = view.bounds; 
     size = .01 * tanf(DEGREES_TO_RADIANS(45.0) / 2.0); 
    
    glFrustumf(-size,                                           // Left
               size,                                           // Right
               -size / (rect.size.width / rect.size.height),    // Bottom
               size / (rect.size.width / rect.size.height),    // Top
               .01,                                          // Near
               1000.0);         

    glViewport(0, 0, rect.size.width, rect.size.height);
    glMatrixMode(GL_MODELVIEW);
	glLoadIdentity(); 
    [self initialize];
  
    }

- (void) loadTextures: (NSString*) path andIndex: (int) index {
    
    glGenTextures(1, &texture[index]);
    glBindTexture(GL_TEXTURE_2D, texture[index]);
    
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR); 
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D, GL_GENERATE_MIPMAP, GL_TRUE);
    
       NSData *texData = [[NSData alloc] initWithContentsOfFile:path];
    UIImage *image = [[UIImage alloc] initWithData:texData];
//    if (image == nil)
  //      return NULL;	
    
    GLuint width = CGImageGetWidth(image.CGImage);
    GLuint height = CGImageGetHeight(image.CGImage);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    void *imageData = malloc( height * width * 4 );
    CGContextRef context = CGBitmapContextCreate( imageData, width, height, 8, 4 * width, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big );
    CGColorSpaceRelease( colorSpace );
    CGContextClearRect( context, CGRectMake( 0, 0, width, height ) );
    CGContextTranslateCTM( context, 0, height - height );
    CGContextDrawImage( context, CGRectMake( 0, 0, width, height ), image.CGImage );
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, imageData);
    
    CGContextRelease(context);
    
    free(imageData);
    [image release];
    [texData release];
    
        
}

- (void)dealloc 
{
    
	[_lblPoints release];
    [super dealloc];
}
@end
