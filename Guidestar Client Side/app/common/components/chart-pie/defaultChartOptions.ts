import * as _ from 'lodash';
let defaultChartOptions = {
                    hover: {
                      animationDuration:100
                    },
                    cutoutPercentage: 45,
                    animation: {
                        animateScale: false,
                        animateRotate: true,
                        duration:400,
                        easing: 'easeOutSine'
                    },
                    layout:{

                    },
                    legend:{
                      display: true,
                      reverse: false, 
                      fullWidth: false,
                      position:"bottom",
                      labels:{
                        usePointStyle: true
                      }
                    },
                    title:{
                        display: false, 
                        text: ''
                    },
                    tooltips:{
                      enabled: false,
                      // intersect: true,
                      // // mode: "index",
                      // backgroundColor: '#627883',
                      // bodyFontFamily: "'opensanshebrew', sans-serif",
                      // displayColors: false,
                      // position: "average",
                      callbacks:{
                        
                      }
                    }
};

export function getDefaultOptions(){
  return defaultChartOptions;
}