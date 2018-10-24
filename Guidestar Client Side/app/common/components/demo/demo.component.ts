import { Component, OnInit } from '@angular/core';
import { DataByYear } from '../data-table/DataByYear';
import { TableByYear } from '../data-table/TableByYear';
import { ChartData } from '../chart-pie/ChartData';
import { HomeService } from '../../../home/home.service';
import { CHART_TMIHOT, CHART_CLASSIFICATION, CHART_DISTRICT } from '../../../home/home.reducer';

@Component({
  selector: 'app-demo',
  templateUrl: './demo.component.html',
  styleUrls: ['./demo.component.css']
})
export class DemoComponent implements OnInit {

  home;
  homeClassifications;
  homeDistricts;
  homeTmihot;
  constructor(private homeService: HomeService) { 
    this.homeService.getHomeChartMainClassifications();
    this.homeService.getHomeChartDistricts();
    this.homeService.getHomeChartTmihot();
    
    this.homeService.home.subscribe(
      home => {
        this.home = home.result;
        this.homeClassifications = home[CHART_CLASSIFICATION];
        this.homeDistricts = home[CHART_DISTRICT];
        this.homeTmihot = home[CHART_TMIHOT];
      }
    );
  }

  getHomeChartTmihot(){
    return this.homeService.getHomeChartTmihot();
  }

  ngOnInit() {
  }

  getChartData(){
    return new Promise<any>(function(resolve, reject){
        setTimeout(function(){
          let result = [<ChartData> {Label:'דת ומדינה', Sum: 5000.595},
                        <ChartData> {Label:'שמואל נעים', Sum: 6000.3838},
                        <ChartData> {Label:'מרדכי בכר', Sum: 7000},
                        <ChartData> {Label:'אלק קובי', Sum: 7000},
                        <ChartData> {Label:'יניב צחי', Sum: 7000},
                        <ChartData> {Label:'יואב דוקטש', Sum: 7000},
                        <ChartData> {Label:'זיו גל', Sum: 7000},
                        <ChartData> {Label:'חינוך', Sum: 7000},
                        <ChartData> {Label:'כלכלה', Sum: 7000},
                        <ChartData> {Label:'אולסיה בוגוד', Sum: 7000},
                        <ChartData> {Label:'אייל לוי', Sum: 7000},
                        <ChartData> {Label:'בתי כנסת', Sum: 2000},
                        <ChartData> {Label:'עמותות זהב', Sum: 500},
                        <ChartData> {Label:'כל האחרים', Sum: 200},
                        ];
          resolve(result);
        }, 1000);
    });
  }
}
