export function remoteFunction(...args): any{
    let Visualforce = window["Visualforce"];
    var myPromise = new Promise(function(resolve, reject){
        Visualforce.remoting.Manager.invokeAction(
            ...args,
            function(result, event) {
                if (event.status)
                    resolve(result);
                else
                    reject(event);
            },{ buffer: true, escape: false, timeout: 120000 });
    });
    return myPromise;
}