import { Component, OnInit, ChangeDetectionStrategy, ChangeDetectorRef } from '@angular/core';
import { FormGroup, FormControl, FormArray, Validators } from '@angular/forms';
import { ContactService } from './contact.service';
import { CommonService } from '../common/services/common.service';
import * as _ from 'lodash';
import { ActivatedRoute, Router } from '@angular/router';
import { CommonStates } from '../common/model/common-states.enum';
import { ContentPosition } from '../common/enums/content-position';
import { AppParams } from '../common/enums/app-params';
import { getBackgroundImageObject, getBackgroundImageUrl } from '../common/utils/utils';

@Component({
  selector: 'app-contact',
  templateUrl: './contact.component.html',
  styleUrls: ['./contact.component.scss'],
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class ContactComponent implements OnInit {

  public getBackgroundImageUrl = getBackgroundImageUrl;
  googleRecaptchaPublicKey: any = AppParams.GoogleRecaptchaPublicKey;
  emailRegEx = '^[a-z0-9._%+-]+@[a-z0-9.-]+\\.[a-z]{2,4}$';
  icoSubmitted: string = 'assets/img/icons/icon-success-desktop.png';
  icoError: string = 'assets/img/icons/icon-failure-desktop.png';
  captchaToken: any;
  isCaptchaExpired: boolean = false;
  isButtonClicked: boolean;
  caseSubmitted: any;
  contactForm: FormGroup;
  Id: FormControl;
  name: FormControl;
  phone: FormControl;
  email: FormControl;
  subject: FormControl;
  body: FormControl;

  upsertErrors: any[] | any;
  upsertStatus: any[] | any;

  userInfo;

  sideContent : any;
  mainContent : any;
  mainContentBody: string[] = [];
  subjectOptions: any;

  $Label: any;

  constructor(
              private contactService: ContactService, 
              private commonService: CommonService,
              private route: ActivatedRoute,
              private router: Router, 
              private ref: ChangeDetectorRef
              ) { 
    this.$Label = window['$Label'];
    this.commonService.setMeta(this.$Label.Site_Contact_Title, this.$Label.Description_Contact);
    this.Id = new FormControl('');
    this.name = new FormControl('', [Validators.required]);
    this.phone = new FormControl('', [Validators.required, Validators.pattern('^[0-9 ]*'), Validators.minLength(7)]);
    this.email = new FormControl('', [Validators.required, Validators.pattern(this.emailRegEx)]);
    this.subject = new FormControl('', [Validators.required]);
    this.body = new FormControl('');

    this.contactForm = new FormGroup({
      Id: this.Id, 
      name: this.name, 
      phone: this.phone, 
      email: this.email, 
      subject: this.subject, 
      body: this.body
    });

    this.commonService.common.subscribe(common => {
      if(_.has(common, CommonStates.userInfo)){
        this.userInfo = common[CommonStates.userInfo];
        this.initFormToDefault(true);
      }
    });
    if(!this.mainContent && !this.sideContent){
      this.getWebsiteContent();
    }
    this.initSubject();
  }

  async initSubject(){
    this.subjectOptions = await this.contactService.getSubjectCasePicklist();
  }

  async getWebsiteContent(){
    let websiteContent = await Promise.all([this.commonService.getWebsiteContent('contact', ContentPosition.Side, AppParams.App),
                                            this.commonService.getWebsiteContent('contact', ContentPosition.Main, AppParams.App)]);
    this.sideContent = websiteContent[0]; 
    this.mainContent = websiteContent[1];
    // this.prepareStyles();
    this.ref.markForCheck();
  }

  // prepareStyles(){
  //   for (let i=0; i<this.mainContent.length; i++){
  //     let tempContent = _.replace(this.mainContent[i].Body, /<img/g, '<img style="max-width: 100%; width: auto; height: auto; border: 1px solid #b2cbcd; padding: 0.8em;"');
  //     tempContent = _.replace(tempContent, /<ul/g, '<ul style="padding-right: 40px;"');
  //     this.mainContentBody.push(tempContent)
  //   }
  // }

  ngOnInit() {
    //this.subjectOptions = this.route.snapshot.data['data'][0];
  }

  initFormToDefault(onlyIfPristine: boolean = false){
    if(onlyIfPristine && !this.contactForm.pristine){
      return;
    }
    if(!_.isEmpty(this.userInfo)){
      this.name.reset(this.userInfo.Name);
      this.phone.reset(this.userInfo.Phone);
      this.email.reset(this.userInfo.Email);
    }
  }

  handleCorrectCaptcha(event){
    this.isCaptchaExpired = false;
    this.captchaToken = event;
  }

  captchaExpired(){
    this.isCaptchaExpired = true;
    this.captchaToken = null;
  }

  async submitCase(){
    this.isButtonClicked = true;
    this.contactForm.markAsTouched();
    if(!this.captchaToken){
      return;
    }
    if(this.isCaptchaExpired){
      return;
    }
    if(this.contactForm.valid){
      try{
        this.upsertErrors = null;
        this.upsertStatus = 'loading...';
        let submittedCase : any = await this.contactService.submitCase(this.contactForm.value, this.captchaToken);
        this.Id.reset(submittedCase.Id);
        this.upsertStatus = 'success';
        // this.router.navigate(['page', 'case-success']);
        this.ref.markForCheck();
      }
      catch(error){
        if(error && error.message){
          this.upsertErrors = error.message;
          this.upsertStatus = 'error';
        }
      }
    }
  }

  resubmitCase(){
    this.contactForm.reset();
    this.upsertErrors = null;
    this.upsertStatus = null;
  }

  getCaseMEssageIcon(){
    if (this.upsertErrors){
      return this.icoError;
    }
    if (this.upsertStatus){
      return this.icoSubmitted;
    }
    return null;
  }

}
