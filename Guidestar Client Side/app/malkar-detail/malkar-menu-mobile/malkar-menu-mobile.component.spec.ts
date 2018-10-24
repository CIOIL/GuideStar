import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { MalkarMenuMobileComponent } from './malkar-menu-mobile.component';

describe('MalkarMenuMobileComponent', () => {
  let component: MalkarMenuMobileComponent;
  let fixture: ComponentFixture<MalkarMenuMobileComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ MalkarMenuMobileComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(MalkarMenuMobileComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
