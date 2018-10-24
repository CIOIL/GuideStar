import { TestBed, inject } from '@angular/core/testing';

import { MalkarDetailService } from './malkar-detail.service';

describe('MalkarDetailService', () => {
  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [MalkarDetailService]
    });
  });

  it('should ...', inject([MalkarDetailService], (service: MalkarDetailService) => {
    expect(service).toBeTruthy();
  }));
});
