# long-text
Simple component for displaying long text with expand/collapse behavior.

# Usage & Demo

The basic use is:
```html
<long-text [htmlBody]="'someString'" [cssClasses]="'some-class some-other-class'" [minHeight]="'3.5em'"></long-text>
```
For more details and examples see:

[https://stackblitz.com/edit/long-text-demo](https://stackblitz.com/edit/long-text-demo)

 - - - 

## Dependencies

***long-text*** requires the new `@angular/animations` package from Angular 4.2+ to work.

This also requires that you `import { BrowserAnimationsModule } from '@angular/platform-browser/animations'` in your app module and add it to the array of imports.


## Documentation

### Inputs (Properties)

- `htmlBody` (`string`) - the text body to be displayed in the component (can contain html markup).
  - Does **not** support angular components. (`[htmlBody]="'<my-component></my-component>'"` is not valid)
- `cssClasses` (`string`) - optional. A space-delimited list of CSS class names to be applied to the content of the component.
  - The class needs to be accessible to this component. There are 2 ways to do this:
    1. Put the class in the parent component of the `<long-text>` component and set `encapsulation: ViewEncapsulation.None` (not recommended).
    2. Put the style class in a globally accessible .css file, such as `style.css` in the app root.
- `minHeight` (`string`) - optional. A value in `em` units that will define the collapsed height of the component.
  - The default value is `3em`, and will be chosen if no input is set.
  - The value must be given in `em` units. Any other units will cause the code to malfuction.

