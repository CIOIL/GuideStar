import { Component, OnInit, Input, Output, EventEmitter, ChangeDetectionStrategy } from '@angular/core';

@Component({
  selector: 'app-search-result',
  templateUrl: './search-result.component.html',
  styleUrls: ['./search-result.component.css'],
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class SearchResultComponent implements OnInit {

  @Input() result : any[] = [];
  @Input() filter : any = {};
  @Input() loading : any;
  @Input() searchWord: string;
  @Output() onLast : EventEmitter<any> = new EventEmitter<any>();
  
  constructor() { }

  ngOnInit() {
  }

  trackByFunc(index, item){
    return item.Id;
  }

  loadMore(item){
    this.onLast.emit(item);
  }

}
