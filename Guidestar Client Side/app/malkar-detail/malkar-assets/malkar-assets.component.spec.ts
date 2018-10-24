import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { MalkarAssetsComponent } from './malkar-assets.component';

describe('MalkarAssetsComponent', () => {
  let component: MalkarAssetsComponent;
  let fixture: ComponentFixture<MalkarAssetsComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ MalkarAssetsComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(MalkarAssetsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
