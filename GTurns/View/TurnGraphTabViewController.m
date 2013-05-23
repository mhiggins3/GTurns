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


@interface TurnGraphTabViewController () <CPTPlotDataSource>

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
    self.plotData = [NSMutableArray arrayWithCapacity:MAX_DATA_POINTS];
    for(int i = 0; i < MAX_DATA_POINTS; i++){
        [self.plotData setObject:[NSNumber numberWithDouble:(1.0 - 0.25) * [[self.plotData lastObject] doubleValue] + 0.25 * rand() / (double)RAND_MAX] atIndexedSubscript:i];
    }
    [self initCharts];
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
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromUnsignedInteger(0) length:CPTDecimalFromUnsignedInteger(51 - 1)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromUnsignedInteger(0) length:CPTDecimalFromUnsignedInteger(1)];

}

-(void) drawAccelerationPlot
{
    
    self.accelerationPlot = [[CPTBarPlot alloc] init];
    self.accelerationPlot.identifier     = ACCELERATION_PLOT_INENTIFIER;
    self.accelerationPlot.cachePrecision = CPTPlotCachePrecisionDouble;
    
    self.accelerationPlot.dataSource = self;
    [self.accelerationView.hostedGraph addPlot:self.accelerationPlot];
    
    // Plot space
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)self.accelerationView.hostedGraph.defaultPlotSpace;
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromUnsignedInteger(0) length:CPTDecimalFromUnsignedInteger(2)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromUnsignedInteger(0) length:CPTDecimalFromUnsignedInteger(1)];
    
}

-(void) drawSpeedPlot
{
    
    self.speedPlot = [[CPTBarPlot alloc] init];
    self.speedPlot.identifier     = SPEED_PLOT_INENTIFIER;
    self.speedPlot.cachePrecision = CPTPlotCachePrecisionDouble;
    
    self.speedPlot.dataSource = self;
    [self.speedView.hostedGraph addPlot:self.speedPlot];
    
    // Plot space
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)self.speedView.hostedGraph.defaultPlotSpace;
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromUnsignedInteger(0) length:CPTDecimalFromUnsignedInteger(2)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromUnsignedInteger(0) length:CPTDecimalFromUnsignedInteger(1)];
    
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
    [self applyGraphDefaults:self.accelerationGraph];
    
    // Grid line styles
    CPTMutableLineStyle *majorGridLineStyle = [CPTMutableLineStyle lineStyle];
    majorGridLineStyle.lineWidth = 0.75;
    majorGridLineStyle.lineColor = [[CPTColor colorWithGenericGray:0.2] colorWithAlphaComponent:0.75];
    
    CPTMutableLineStyle *minorGridLineStyle = [CPTMutableLineStyle lineStyle];
    minorGridLineStyle.lineWidth = 0.25;
    minorGridLineStyle.lineColor = [[CPTColor whiteColor] colorWithAlphaComponent:0.1];
    
    // Axes
    // X axis
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)self.accelerationGraph.axisSet;
    CPTXYAxis *x = axisSet.xAxis;
    
    x.labelingPolicy              = CPTAxisLabelingPolicyAutomatic;
    x.orthogonalCoordinateDecimal = CPTDecimalFromUnsignedInteger(0);
    x.majorGridLineStyle          = majorGridLineStyle;
    x.minorGridLineStyle          = minorGridLineStyle;
    x.minorTicksPerInterval       = 1;
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
    y.minorTicksPerInterval       = 1;
    y.labelOffset                 = 5.0;
    y.title                       = @"Y Axis";
    y.titleOffset                 = 30.0;
    y.axisConstraints             = [CPTConstraints constraintWithLowerOffset:0.0];
    

    
}

-(void) initSpeedGraph
{
    
    self.speedGraph = [[CPTXYGraph alloc] initWithFrame:self.speedView.bounds];
    self.speedView.hostedGraph = self.speedGraph;
    self.speedGraph.title = SPEED_PLOT_INENTIFIER;
    [self applyGraphDefaults:self.speedGraph];
    
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
    y.title                       = @"Y Axis";
    y.titleOffset                 = 30.0;
    y.axisConstraints             = [CPTConstraints constraintWithLowerOffset:0.0];

}

#pragma mark - CPTPlotDataSource methods
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
     
    if([plot.identifier isEqual:LATERAL_PLOT_INENTIFIER]){
        return [self.plotData count];
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
                num = [NSNumber numberWithUnsignedInteger:index];
                break;
                
            case CPTScatterPlotFieldY:
                num = [self.plotData objectAtIndex:index];
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
                num = [NSNumber numberWithInt:2.5];
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
                num = [NSNumber numberWithInt:50];
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

@end
