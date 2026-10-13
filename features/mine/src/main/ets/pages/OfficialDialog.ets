import { BusinessError } from '@kit.BasicServicesKit';
import { ComponentContent, promptAction } from '@kit.ArkUI';
import { UIContext } from '@ohos.arkui.UIContext';

export class OfficialDialog {
  static ctx: UIContext;
  static contentNode: ComponentContent<Object>;
  static options: promptAction.BaseDialogOptions;

  static setContext(context: UIContext) {
    OfficialDialog.ctx = context;
  }

  static setContentNode(node: ComponentContent<Object>) {
    OfficialDialog.contentNode = node;
  }

  static setOptions(options: promptAction.BaseDialogOptions) {
    OfficialDialog.options = options;
  }

  static openDialog() {
    if (OfficialDialog.contentNode !== null) {
      OfficialDialog.ctx.getPromptAction().openCustomDialog(OfficialDialog.contentNode, OfficialDialog.options)
        .then(() => {
          console.info('OpenCustomDialog complete.')
        })
        .catch((error: BusinessError) => {
          let message = (error as BusinessError).message;
          let code = (error as BusinessError).code;
          console.error(`OpenCustomDialog args error code is ${code}, message is ${message}`);
        })
    }
  }

  static closeDialog() {
    if (OfficialDialog.contentNode !== null) {
      OfficialDialog.ctx.getPromptAction().closeCustomDialog(OfficialDialog.contentNode)
        .then(() => {
          console.info('CloseCustomDialog complete.')
        })
        .catch((error: BusinessError) => {
          let message = (error as BusinessError).message;
          let code = (error as BusinessError).code;
          console.error(`CloseCustomDialog args error code is ${code}, message is ${message}`);
        })
    }
  }

  static updateDialog(options: promptAction.BaseDialogOptions) {
    if (OfficialDialog.contentNode !== null) {
      OfficialDialog.ctx.getPromptAction().updateCustomDialog(OfficialDialog.contentNode, options)
        .then(() => {
          console.info('UpdateCustomDialog complete.')
        })
        .catch((error: BusinessError) => {
          let message = (error as BusinessError).message;
          let code = (error as BusinessError).code;
          console.error(`UpdateCustomDialog args error code is ${code}, message is ${message}`);
        })
    }
  }
}