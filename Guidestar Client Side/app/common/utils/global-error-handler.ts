import { ErrorHandler } from '@angular/core';
import { remoteFunction } from './remote';

export class GlobalErrorHandler extends ErrorHandler{

  constructor(){
    super();
  }

  handleError(er){
    let res = remoteFunction('Utils_RemoteAction.createJSError', document.URL, er.message, er.stack);
    //document.URL --> URL
    //er.message --> FullMessage    
    //er.stack --> Description
    super.handleError(er);
  }
}
