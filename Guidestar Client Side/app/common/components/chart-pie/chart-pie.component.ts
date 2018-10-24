import { ViewChild, Component, ElementRef, OnInit, Input, OnChanges, SimpleChanges, ViewEncapsulation, HostListener, OnDestroy, ChangeDetectionStrategy, ChangeDetectorRef } from '@angular/core';
import { DecimalPipe } from '@angular/common';
import Chart from 'chart.js';
import { getDefaultChartColors, getAccessibilityColors } from './defaultChartColors';
import { getDefaultOptions } from './defaultChartOptions';
import * as _ from 'lodash';
import { ChartData } from './ChartData';
import { CommonService } from '../../services/common.service';
import { COMMON_GRAPH_COLORS, COMMON_GRAPH_DISPLAY } from '../../ngrx/common.actions';
import { Subscription } from 'rxjs';
import { AppParams } from '../../enums/app-params';


@Component({
  selector: 'app-chart-pie',
  templateUrl: './chart-pie.component.html',
  styleUrls: ['./chart-pie.component.scss'],
  encapsulation: ViewEncapsulation.Emulated,
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class ChartPieComponent implements OnChanges, OnDestroy {

  @HostListener('window:resize', ['$event']) 
  onResize(event){
    this.chartRectHeight = 'auto';
    if (this.chart){
      this.chart.resize();
    }
  };
  
  @ViewChild('donut') donut: ElementRef  ;
  @ViewChild('tooltipParent') tooltipParent: ElementRef  ;
  @ViewChild('chartDisplay') chartDisplay: ElementRef  ;
  @ViewChild('listDisplay') listDisplay: ElementRef  ;
  public canvasCtx: any;
  public chart: any;
  public data:number[] | any[];
  public labels:Array<any> = [];
  public defaultChartColors = getDefaultChartColors();
  public accessibilityColors = getAccessibilityColors();
  public legendData: any;
  public total: number;
  public defaultChartOptions:any;
  public colorSource: string[] = this.defaultChartColors;
  $Label: any;
  subs: Subscription[] = [];
  showList: boolean = false;
  chartRectHeight: string = 'auto';
  oldCommonServiceValues: any = {};


  @Input() public options:any = {};
  @Input() public showTotal: boolean = true;
  @Input() public showBlankTotal: boolean = false;
  @Input() public showTotalInLegend: boolean = true;
  @Input() public showLegendInfo: boolean = false;
  @Input() public currency:string = '';
  @Input() public chartType:string = 'doughnut';
  @Input() public chartHeight: string = '80';
  @Input() public colors:Array<any>;
  @Input() public legend:boolean = false;
  @Input() public dataFunction: Function;
  @Input() public minHeightLegend: string = '4.125em';
  @Input() public seeAllLegend: boolean = false;
  @Input() public cutoutPercentage: number = 60;
  @Input() items: any;
  @Input() sumStyle: any;
  @Input() bucketSum: number;
  @Input() bucketHidden: boolean = false;
  @Input() showLargeButton: boolean;
  @Input() showSmallButton: boolean;

  constructor(private commonService: CommonService, private elementRef: ElementRef, private decimalPipe: DecimalPipe, private ref: ChangeDetectorRef) { 
    // Chart.defaults.global.tooltips.custom = this.generateTooltip;
    this.$Label = window['$Label'];
    this.initData();
  }

  ngOnChanges(changes: SimpleChanges){
    if(changes['items']){
      this.dataPromiseCallback(this.items);
    }
  }

  ngOnDestroy(){
    for (let i=0; i<this.subs.length; i++){
      this.subs[i].unsubscribe();
    }
  }

  initData(){
    if(this.dataFunction){
      this.dataFunction().then(result => {
        this.dataPromiseCallback(result);
      });
    }
    this.subs.push(this.commonService.common.subscribe(res =>{
      if (_.has(res, COMMON_GRAPH_COLORS)){
        this.setColorSource(res[COMMON_GRAPH_COLORS]);
      }
      if (_.has(res, COMMON_GRAPH_DISPLAY)){
        this.setDisplayMode(res[COMMON_GRAPH_DISPLAY]);
      }
      this.ref.markForCheck();
    }));
  }

  setColorSource(value){
    if (this.oldCommonServiceValues[COMMON_GRAPH_COLORS] && this.oldCommonServiceValues[COMMON_GRAPH_COLORS] === value){
      return;
    }
    this.oldCommonServiceValues[COMMON_GRAPH_COLORS] = value;
    if (value === AppParams.graphColorsDefault){
      this.colorSource = this.defaultChartColors;
    }
    else{
      this.colorSource = this.accessibilityColors;
    }
    if (this.chart){
      this.instatiateChart();
    }
  }

  setDisplayMode(value){
    if (this.oldCommonServiceValues[COMMON_GRAPH_DISPLAY] && this.oldCommonServiceValues[COMMON_GRAPH_DISPLAY] === value){
      return;
    }
    this.oldCommonServiceValues[COMMON_GRAPH_DISPLAY] = value;
    if (value === AppParams.graphDisplayList){
      this.showList = true;
      if (this.chartDisplay){
        this.chartRectHeight = this.chartDisplay.nativeElement.getBoundingClientRect().height + 'px';
      }
    }
    else{
      this.showList = false;
      setTimeout(() => {
        this.instatiateChart();
      }, 500);
    }
  }

  dataPromiseCallback(result){
    // console.log(result);
    let tempSumList = _.map(result, 'Sum');
    let tempLabelList = _.map(result, 'Label');
    this.total = _.sum(tempSumList);
    let oneSet;
    if (this.bucketSum){
      oneSet = this.calculateGraph(tempSumList, tempLabelList);
    }
    else{
      this.labels = tempLabelList;
      oneSet = tempSumList;
    }
    let backgroundColors = this.getBackgroundColors(oneSet.length);
    this.data = [{data: oneSet, backgroundColor: backgroundColors}];
    if(this.chart){
      this.chart.data = this.getDataChartObject();
      this.chart.update();
      this.legendData = this.chart.generateLegend();
    }
    this.ref.markForCheck();
  }

  calculateGraph(sumList, labelList): number[]{
    let oneSet: number[] = [];
    this.labels = [];
    let bucketSums = 0;
    for (let i=0; i<sumList.length; i++){
      if ((sumList[i]/this.total*100) > this.bucketSum){
        this.labels.push(labelList[i]);
        oneSet.push(sumList[i]);
      }
      else{
        bucketSums += sumList[i];
      }
    }
    if (bucketSums > 0 && !this.bucketHidden){
      oneSet.push(bucketSums);
      this.labels.push(this.$Label['GSTAR_Other'])
    }
    return oneSet;
  }

  getBackgroundColors(size){
    if(!_.isEmpty(this.colors)){
      return this.colors;
    }
    else{
      // return _.map([...new Array(size)], () => defaultChartColors[Math.round(Math.random() * (this.defaultChartColors.length - 1))]);
      let arrayColors = [];
      let baseColorsTimes = Math.ceil(size / this.colorSource.length);
      for(let i = 0; i < baseColorsTimes ; i++){
        let randomArray = this.shuffle(this.colorSource);
        arrayColors = [...arrayColors,...randomArray];
      }
      return arrayColors;
    }
  }

  shuffle(data) {
      let dataRandom = [];
      for (let a = [...data], i = a.length; i--; ) {
        dataRandom.push(a.splice(Math.floor(Math.random() * (i + 1)), 1)[0]);
      } 
      return dataRandom;
  };

  init() {
    this.defaultChartOptions = Object.assign({}, getDefaultOptions());
    this.options = Object.assign(this.defaultChartOptions, this.options);
    this.options.legend.display = this.legend;
    this.options.legendCallback = this.getLegendCallback;
    this.options.cutoutPercentage = this.cutoutPercentage;
    // this.options['tooltips']['custom'] = this.generateTooltip;
    this.options.tooltips.callbacks.label = (tooltipItems, data) => {
      return this.generateTooltipCallback(tooltipItems, data)
    };
    this.options.tooltips.custom = (tooltip, args) =>{
      return this.generateTooltip(tooltip, args);
    };
    this.options.tooltips.currency = this.currency;
    this.options.tooltips.showTotalInLegend = this.showTotalInLegend;
  }

  ngAfterViewInit(){
    this.instatiateChart();
  }

  instatiateChart(){
    this.init();
    this.canvasCtx = this.donut.nativeElement.getContext("2d");
    // this.extendDoughnut();
    this.chart = new Chart(this.canvasCtx,{
        type: this.chartType,
        data: this.getDataChartObject(),
        options: this.options
    });
    if(this.items){
      this.dataPromiseCallback(this.items);
    }
  }

  onclickLegend(legendItem){
    // setTimeout(() => alert(legendItem.text), 1000);
  }

  getTitle(legendItem){
    let part = _.floor(this.data[0].data[legendItem.index] * 1000 / this.total) / 10;
    /*
    if(this.showTotalInLegend){
      return [', ', this.data[0].data[legendItem.index],
              part + '%'];
    }
    else{
      return [', ' + part + '%'];
    }
    */
    return [', ' + part + '%'];
  }

  getDataChartObject(){
    return {datasets: this.data, labels: this.labels};
  }

  getLegendCallback(chart){
    return chart.legend.legendItems;
  };

  generateTooltipCallback(tooltipItems, data){
    let sum = _.sum(data.datasets[0].data);
    let partSum = data.datasets[0].data[tooltipItems.index];
    let part = _.floor(partSum * 1000 / sum) / 10;
    let showPartSum = this.decimalPipe.transform(partSum, '1.0-0');
    showPartSum += ' ' + this.currency;
    if(this.showTotalInLegend){
      return [  data.labels[tooltipItems.index],
              showPartSum,
              part + '%'];
    }
    else{
      return [  data.labels[tooltipItems.index],
              part + '%'];
    }
  }

  extendDoughnut(){
    Chart.types.Doughnut.extend({
        name: "DoughnutTextInside",
        draw: function() {
            Chart.types.Doughnut.prototype.draw.apply(this, arguments);

            var width = this.chart.width,
                height = this.chart.height;

            var fontSize = (height / 114).toFixed(2);
            this.chart.ctx.font = fontSize + "em Verdana";
            this.chart.ctx.textBaseline = "middle";

            var text = "82%",
                textX = Math.round((width - this.chart.ctx.measureText(text).width) / 2),
                textY = height / 2;

            this.chart.ctx.fillText(text, textX, textY);
        }
    });
  }
  
  generateTooltip(tooltip, ...args){
    let tooltipEl : any = this.tooltipParent.nativeElement;//document.getElementById('chartjs-tooltip');
		// Hide if no tooltip
		if (tooltip.opacity === 0) {
			// tooltipEl.style.opacity = 0;
      // tooltipEl.style.display = 'none';
      tooltipEl.parentElement.style.cursor = 'default';
			return;
		}
		// Set caret Position
		tooltipEl.classList.remove('above', 'below', 'no-transform');
		if (tooltip.yAlign) {
			tooltipEl.classList.add(tooltip.yAlign);
		} else {
			tooltipEl.classList.add('no-transform');
		}

		// Set Text
		if (tooltip.body) {
			let bodyLines = tooltip.body[0].lines;
			let innerHtml = '';
      bodyLines.forEach((line, i) => {
        innerHtml += '<div class="chartjs-tooltip-key" style="padding: 0 0 0.3em 0">' + line + '</div>';
      });
			let tableRoot = tooltipEl.querySelector('div');
			tableRoot.innerHTML = innerHtml;
		}

		let position: any = this.chart.canvas.getBoundingClientRect();
		// Display, position, and set styles for font
    // debugger;
		tooltipEl.style.opacity = 1;
		// tooltipEl.style.left = position.left + tooltip.caretX + 'px';
		// tooltipEl.style.top = position.top + tooltip.caretY + 'px';
    tooltipEl.style.left = tooltip.caretX +'px';
    tooltipEl.style.top = tooltip.caretY +'px';
		tooltipEl.style.padding = tooltip.yPadding + 'px ' + tooltip.xPadding + 'px';
    tooltipEl.style.display = 'block';
    tooltipEl.parentElement.style.cursor = 'pointer';
  }

  hideTooltip(){
    let tooltipEl : any = this.tooltipParent.nativeElement;
    tooltipEl.style.display = 'none';
  }
}
