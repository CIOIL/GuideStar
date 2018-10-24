import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { MalkarMapComponent } from './malkar-map.component';

describe('MalkarMapComponent', () => {
  let component: MalkarMapComponent;
  let fixture: ComponentFixture<MalkarMapComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ MalkarMapComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(MalkarMapComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
