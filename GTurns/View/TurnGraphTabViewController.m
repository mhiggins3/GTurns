//
//  TurnGraphTabViewController.m
//  GTurns
//
//  Created by Matt Higgins on 5/21/13.
//  Copyright (c) 2013 Matt Higgins. All rights reserved.
//

#import "TurnGraphTabViewController.h"

NSString *const LATERAL_PLOT_INENTIFIER =           @"Lateral G Plot";
NSString *const ACCELERATION_PLOT_INENTIFIER =      @"Acceleration G Plot";
NSString *const SPEED_PLOT_INENTIFIER =             @"Current Speed";
const NSInteger MAX_DATA_POINTS = 51;


@interface TurnGraphTabViewController () <CPTPlotDataSource,CLLocationManagerDelegate,BTManagerDelegate>

    @property (strong) NSMutableArray        *plotData;

    /**
     Core plot has 3 steps for drawing a plot in a graph
        1. Setup a view to contain your graph. This view will be a sub view
            of a view contoller. Here you setup bounds and position of your
            sub view which will eventually contain your plot with a
            CGRect. 
        2. Create a graph space in your view where your plot will be held. 
            this graph space sets up bounds for your plot in your view.
            Themes can also be applied at this level.
        3. Finally the plot will represent how your data is represented. 
            This defines the plot type such as a bar plot or a scatter.
     */
    @property (strong) CPTGraphHostingView   *lateralView;
    @property (strong) CPTGraphHostingView   *accelerationView;
    @property (strong) CPTGraphHostingView   *speedView;

    @property (strong) CPTXYGraph   *lateralGraph;
    @property (strong) CPTXYGraph   *accelerationGraph;
    @property (strong) CPTXYGraph   *speedGraph;

    @property (strong) CPTScatterPlot   *lateralPlot;
    @property (strong) CPTBarPlot       *accelerationPlot;
    @property (strong) CPTBarPlot       *speedPlot;

    @property (strong) CLLocationManager *locationManager;
    @property float lastMph;
    @property float lastAccl;


    @property (strong) BTManager *btManager;

    @property NSInteger lateralGPlotCount;
    @property NSMutableArray *lateralGPlotData;

@end

@implementation TurnGraphTabViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    for(int i = 0; i < MAX_DATA_POINTS; i++){
        [self.plotData setObject:[NSNumber numberWithDouble:(1.0 - 0.25) * [[self.plotData lastObject] doubleValue] + 0.25 * rand() / (double)RAND_MAX] atIndexedSubscript:i];
    }
    [self initCharts];

    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    self.lastMph = 0.0;
    
    self.btManager = [BTManager sharedInstance];
    self.btManager.delegate = self;

    self.lateralGPlotCount = 0;
    self.lateralGPlotData = [NSMutableArray arrayWithCapacity:MAX_DATA_POINTS];
}
- (void)viewWillAppear:(BOOL)animated
{
    self.btManager = [BTManager sharedInstance];
    self.btManager.delegate = self;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initCharts
{
    [self initHostViews];
    
    [self initLateralGraph];
    [self initAccelerationGraph];
    [self initSpeedGraph];
    
    [self drawLateralPlot];
    [self drawAccelerationPlot];
    [self drawSpeedPlot];

}

-(void) drawLateralPlot
{
    
    self.lateralPlot = [[CPTScatterPlot alloc] init];
    self.lateralPlot.identifier     = LATERAL_PLOT_INENTIFIER;
    self.lateralPlot.cachePrecision = CPTPlotCachePrecisionDouble;
    // Make the data source line smooth
    self.lateralPlot.interpolation = CPTScatterPlotInterpolationCurved;
    
    CPTMutableLineStyle *lineStyle = [self.lateralPlot.dataLineStyle mutableCopy];
    lineStyle.lineWidth              = 3.0;
    lineStyle.lineColor              = [CPTColor greenColor];
    self.lateralPlot.dataLineStyle = lineStyle;
    
    self.lateralPlot.dataSource = self;
    [self.lateralView.hostedGraph addPlot:self.lateralPlot];
    
    // Plot space
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)self.lateralView.hostedGraph.defaultPlotSpace;
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-3.0) length:CPTDecimalFromUnsignedInteger(6)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromUnsignedInteger(-5.0) length:CPTDecimalFromUnsignedInteger(55)];

}

-(void) drawAccelerationPlot
{
    
    self.accelerationPlot = [CPTBarPlot tubularBarPlotWithColor: [CPTColor greenColor] horizontalBars:NO];
    self.accelerationPlot.identifier     = ACCELERATION_PLOT_INENTIFIER;
    self.accelerationPlot.cachePrecision = CPTPlotCachePrecisionDouble;
    
    self.accelerationPlot.dataSource = self;
    [self.accelerationView.hostedGraph addPlot:self.accelerationPlot];
    
    // Plot space
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)self.accelerationView.hostedGraph.defaultPlotSpace;
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(3.0)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation: CPTDecimalFromFloat(-3.0) length: CPTDecimalFromFloat(6.0)];
    
}

-(void) drawSpeedPlot
{
    
    self.speedPlot = [CPTBarPlot tubularBarPlotWithColor: [CPTColor greenColor] horizontalBars:NO];
    self.speedPlot.identifier     = SPEED_PLOT_INENTIFIER;
    self.speedPlot.cachePrecision = CPTPlotCachePrecisionDouble;
    
    CPTMutableLineStyle *lineStyle = [self.lateralPlot.dataLineStyle mutableCopy];
    lineStyle.lineWidth              = 3.0;
    lineStyle.lineColor              = [CPTColor greenColor];


    
    self.speedPlot.dataSource = self;
    [self.speedView.hostedGraph addPlot:self.speedPlot];
    
    // Plot space
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)self.speedView.hostedGraph.defaultPlotSpace;
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0) length:CPTDecimalFromFloat(3)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-10.0) length:CPTDecimalFromFloat(220)];
    
}

-(void) initLateralGraph
{
    
    self.lateralGraph = [[CPTXYGraph alloc] initWithFrame:self.lateralView.bounds];
    self.lateralView.hostedGraph = self.lateralGraph;
    self.lateralGraph.title = LATERAL_PLOT_INENTIFIER;
    [self applyGraphDefaults:self.lateralGraph];
    
}

-(void) initAccelerationGraph
{
    
    self.accelerationGraph = [[CPTXYGraph alloc] initWithFrame:self.accelerationView.bounds];
    self.accelerationView.hostedGraph = self.accelerationGraph;
    self.accelerationGraph.title = ACCELERATION_PLOT_INENTIFIER;
    CPTMutableTextStyle *titleStyle =  [CPTMutableTextStyle textStyle];
    titleStyle.fontSize = 12.0f;
    titleStyle.color = [CPTColor whiteColor];

    
    self.accelerationGraph.titleTextStyle =  titleStyle;
    //[self applyGraphDefaults:self.accelerationGraph];
   
    [self.accelerationGraph applyTheme:[CPTTheme themeNamed:@"Dark Gradients"]];
    self.accelerationGraph.paddingLeft = 5.f;
    self.accelerationGraph.paddingTop = 5.0f;
    self.accelerationGraph.paddingRight = 5.0f;
    self.accelerationGraph.paddingBottom = 30.0f;

    // Grid line styles
    CPTMutableLineStyle *majorGridLineStyle = [CPTMutableLineStyle lineStyle];
    majorGridLineStyle.lineWidth = 0.80;
    majorGridLineStyle.lineColor = [[CPTColor colorWithGenericGray:0.2] colorWithAlphaComponent:0.75];
    
    CPTMutableLineStyle *minorGridLineStyle = [CPTMutableLineStyle lineStyle];
    minorGridLineStyle.lineWidth = 0.25;
    minorGridLineStyle.lineColor = [[CPTColor whiteColor] colorWithAlphaComponent:0.1];
    
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)self.accelerationGraph.axisSet;
    CPTXYAxis *x = axisSet.xAxis;
    x.hidden = YES;
    
    
    // Y axis
    CPTXYAxis *y = axisSet.yAxis;
    y.labelingPolicy              = CPTAxisLabelingPolicyAutomatic;
    y.orthogonalCoordinateDecimal = CPTDecimalFromUnsignedInteger(0);
    y.majorGridLineStyle          = majorGridLineStyle;
    y.minorGridLineStyle          = minorGridLineStyle;
    y.minorTicksPerInterval       = 10;
    y.labelOffset                 = 5.0;
    y.titleOffset                 = 30.0;
    y.axisConstraints             = [CPTConstraints constraintWithLowerOffset:125.0];
    
    y.visibleAxisRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-2.0) length:CPTDecimalFromFloat(4.0)];

    
}

-(void) initSpeedGraph
{
    
    self.speedGraph = [[CPTXYGraph alloc] initWithFrame:self.speedView.bounds];
    self.speedView.hostedGraph = self.speedGraph;
    self.speedGraph.title = SPEED_PLOT_INENTIFIER;
    //[self applyGraphDefaults:self.speedGraph];
    CPTMutableTextStyle *titleStyle =  [CPTMutableTextStyle textStyle];
    titleStyle.fontSize = 12.0f;
    titleStyle.color = [CPTColor whiteColor];
    
    
    self.speedGraph.titleTextStyle =  titleStyle;

    [self.speedGraph applyTheme:[CPTTheme themeNamed:@"Dark Gradients"]];
    self.speedGraph.paddingLeft = 5.f;
    self.speedGraph.paddingTop = 5.0f;
    self.speedGraph.paddingRight = 5.0f;
    self.speedGraph.paddingBottom = 30.0f;
    
    // Grid line styles
    CPTMutableLineStyle *majorGridLineStyle = [CPTMutableLineStyle lineStyle];
    majorGridLineStyle.lineWidth = 0.8;
    majorGridLineStyle.lineColor = [[CPTColor colorWithGenericGray:0.2] colorWithAlphaComponent:0.75];
    
    CPTMutableLineStyle *minorGridLineStyle = [CPTMutableLineStyle lineStyle];
    minorGridLineStyle.lineWidth = 0.25;
    minorGridLineStyle.lineColor = [[CPTColor whiteColor] colorWithAlphaComponent:0.1];
    
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)self.speedGraph.axisSet;
    CPTXYAxis *x = axisSet.xAxis;
    x.hidden = YES;
    
    // Y axis
    CPTXYAxis *y = axisSet.yAxis;
    y.labelingPolicy              = CPTAxisLabelingPolicyAutomatic;
    y.orthogonalCoordinateDecimal = CPTDecimalFromUnsignedInteger(0);
    y.majorGridLineStyle          = majorGridLineStyle;
    y.minorGridLineStyle          = minorGridLineStyle;
    y.minorTicksPerInterval       = 10;
    y.labelOffset                 = 5.0;
    y.titleOffset                 = 30.0;
    y.axisConstraints             = [CPTConstraints constraintWithLowerOffset:125.0];
    y.visibleAxisRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(1) length:CPTDecimalFromFloat(180)];

    
}

-(void)initHostViews
{

    //TODO: Get Const for tab bar height .... 49
    //Get our bounds
    CGRect parentRect = self.view.bounds;

    //Init lateralView
    self.lateralView = [[CPTGraphHostingView alloc] initWithFrame:CGRectMake(0,
                                                                                 0,
                                                                                 parentRect.size.height / 2,
                                                                                 parentRect.size.width - 49)];
    self.lateralView.allowPinchScaling = NO;
    self.lateralView.autoresizesSubviews = YES;
    self.lateralView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.lateralView];
    
    
    //Init accelerationView
    self.accelerationView = [[CPTGraphHostingView alloc] initWithFrame:CGRectMake(parentRect.size.height / 2,
                                                                                 0,
                                                                                 parentRect.size.height / 4,
                                                                                 parentRect.size.width - 49)];
    self.accelerationView.allowPinchScaling = NO;
    self.accelerationView.autoresizesSubviews = YES;
    self.accelerationView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.accelerationView];

    //Init speedView
    self.speedView = [[CPTGraphHostingView alloc] initWithFrame:CGRectMake(parentRect.size.height * 0.75,
                                                                                  0,
                                                                                  parentRect.size.height / 4,
                                                                                  parentRect.size.width - 49)];
    self.speedView.allowPinchScaling = NO;
    self.speedView.autoresizesSubviews = YES;
    self.speedView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.speedView];
    
}

-(void) applyGraphDefaults:(CPTXYGraph *) graph
{

    [graph applyTheme:[CPTTheme themeNamed:@"Dark Gradients"]];
    graph.paddingLeft = 5.f;
    graph.paddingTop = 5.0f;
    graph.paddingRight = 5.0f;
    graph.paddingBottom = 30.0f;
    
    CPTMutableTextStyle *titleStyle =  [CPTMutableTextStyle textStyle];
    titleStyle.fontSize = 12.0f;
    titleStyle.color = [CPTColor whiteColor];
    graph.titleTextStyle = titleStyle;
    
    // Grid line styles
    CPTMutableLineStyle *majorGridLineStyle = [CPTMutableLineStyle lineStyle];
    majorGridLineStyle.lineWidth = 0.75;
    majorGridLineStyle.lineColor = [[CPTColor colorWithGenericGray:0.2] colorWithAlphaComponent:0.75];
    
    CPTMutableLineStyle *minorGridLineStyle = [CPTMutableLineStyle lineStyle];
    minorGridLineStyle.lineWidth = 0.25;
    minorGridLineStyle.lineColor = [[CPTColor whiteColor] colorWithAlphaComponent:0.1];
    
    // Axes
    // X axis
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
    CPTXYAxis *x = axisSet.xAxis;
    
    x.labelingPolicy              = CPTAxisLabelingPolicyAutomatic;
    x.orthogonalCoordinateDecimal = CPTDecimalFromUnsignedInteger(0);
    x.majorGridLineStyle          = majorGridLineStyle;
    x.minorGridLineStyle          = minorGridLineStyle;
    x.minorTicksPerInterval       = 9;
    x.title                       = @"X Axis";
    x.titleOffset                 = 35.0;
    NSNumberFormatter *labelFormatter = [[NSNumberFormatter alloc] init];
    labelFormatter.numberStyle = NSNumberFormatterNoStyle;
    x.labelFormatter           = labelFormatter;
    
    // Y axis
    CPTXYAxis *y = axisSet.yAxis;
    y.labelingPolicy              = CPTAxisLabelingPolicyAutomatic;
    y.orthogonalCoordinateDecimal = CPTDecimalFromUnsignedInteger(0);
    y.majorGridLineStyle          = majorGridLineStyle;
    y.minorGridLineStyle          = minorGridLineStyle;
    y.minorTicksPerInterval       = 3;
    y.labelOffset                 = 5.0;
    y.titleOffset                 = 30.0;
    y.title = @"";
    y.axisConstraints             = [CPTConstraints constraintWithLowerOffset:135.0];
    y.visibleAxisRange            = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0) length:CPTDecimalFromFloat(50)];
    y.paddingBottom = 20.0;


}
-(void) updateSpeedChart
{
    //[self.speedPlot insertDataAtIndex:0 numberOfRecords:1];
    [self.speedPlot reloadData];
    
}
-(void) updateAccelerationChart:(float ) zValue
{
    self.lastAccl = zValue;
    [self.accelerationPlot reloadData];

}
-(void) updateLateralChart:(float) yValue
{
    if ( self.lateralGPlotData.count >= MAX_DATA_POINTS ) {
        [self.lateralGPlotData removeObjectAtIndex:0];
        [self.lateralPlot deleteDataInIndexRange:NSMakeRange(0, 1)];
    }
    
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)self.lateralGraph.defaultPlotSpace;
    NSUInteger location       = (self.lateralGPlotCount >= MAX_DATA_POINTS ? self.lateralGPlotCount - MAX_DATA_POINTS + 1 : 0);
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromUnsignedInteger(location)
                                                    length:CPTDecimalFromUnsignedInteger(MAX_DATA_POINTS - 1)];
    
    self.lateralGPlotCount++;
    [self.lateralGPlotData addObject:[NSNumber numberWithFloat:-yValue]];
    [self.lateralPlot insertDataAtIndex:self.lateralGPlotData.count - 1 numberOfRecords:1];

}

#pragma mark - CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *currentLocation = [locations objectAtIndex:locations.count - 1];
    if(currentLocation.speed > 0){
        self.lastMph = (currentLocation.speed * 3.6)/ 1.609344;
    }
    [self updateSpeedChart];
    
}
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    NSLog(@"didChangeAuthorizationStatus: UNIMPLIMENTED");
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: UNIMPLIMENTED %@", error);
}

#pragma mark - CPTPlotDataSource methods
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
     
    if([plot.identifier isEqual:LATERAL_PLOT_INENTIFIER]){
        //return [self.plotData count];
        return [self.lateralGPlotData count];
    } else if([plot.identifier isEqual:ACCELERATION_PLOT_INENTIFIER]){
        return 1;
    } else if([plot.identifier isEqual:SPEED_PLOT_INENTIFIER]){
        return 1;
    }
    return -1;
    
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
    NSNumber *num = nil;
    
    
    if([plot.identifier isEqual:LATERAL_PLOT_INENTIFIER]){
        switch ( fieldEnum ) {
            case CPTScatterPlotFieldX:
                //num = [NSNumber numberWithUnsignedInteger:index + currentIndex - plotData.count];
                num = [self.lateralGPlotData objectAtIndex:index];
                break;
                
            case CPTScatterPlotFieldY:
                
                num = [NSNumber numberWithUnsignedInteger:index + self.lateralGPlotCount - self.lateralGPlotData.count];

                break;
                
            default:
                break;
        }
    } else if([plot.identifier isEqual:ACCELERATION_PLOT_INENTIFIER]){
        switch ( fieldEnum ) {
            case CPTScatterPlotFieldX:
                num = [NSNumber numberWithInt:1];
                break;
                
            case CPTScatterPlotFieldY:
                num = [NSNumber numberWithFloat:self.lastAccl];
                break;
                
            default:
                break;
        }

    } else if([plot.identifier isEqual:SPEED_PLOT_INENTIFIER]){
        switch ( fieldEnum ) {
            case CPTScatterPlotFieldX:
                num = [NSNumber numberWithInt:1];
                break;
                
            case CPTScatterPlotFieldY:
                num = [NSNumber numberWithFloat:self.lastMph];
                break;
                
            default:
                break;
        }
    }
  
    
    return num;
}

-(CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index {
    return nil;
}
#pragma mark - BTManagerDelegate
-(void)didUpdateAccelerometerValues:(AccelerometerSensor *)accelerometer
{
    [self updateAccelerationChart: accelerometer.zValue];
    [self updateLateralChart: accelerometer.yValue];

}
@end
