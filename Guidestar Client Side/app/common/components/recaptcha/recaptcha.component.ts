import { Component, OnInit, ViewChild, Input } from '@angular/core';
import { remoteFunction } from '../../utils/remote';
import { AppParams } from '../../enums/app-params';

@Component({
  selector: 'app-recaptcha',
  templateUrl: './recaptcha.component.html',
  styleUrls: ['./recaptcha.component.css']
})
export class RecaptchaComponent implements OnInit {

  googleRecaptchaPublicKey : AppParams = AppParams.GoogleRecaptchaPublicKey;
  @Input() callback: any;
  constructor() { }

  ngOnInit() {
  }

  handleCorrectCaptcha(event){
    remoteFunction('Utils_RemoteAction.verifyRecaptcha', event).then(res => res ? this.callback(): res);
  }

  captchaExpired(){
    
  }

}
