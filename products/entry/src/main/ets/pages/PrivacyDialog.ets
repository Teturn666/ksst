import { BusinessError } from '@kit.BasicServicesKit';
import { ComponentContent, promptAction } from '@kit.ArkUI';
import { UIContext } from '@ohos.arkui.UIContext';

export class PrivacyDialog {
  static ctx: UIContext;
  static contentNode: ComponentContent<Object>;
  static options: promptAction.BaseDialogOptions;

  static setContext(context: UIContext) {
    PrivacyDialog.ctx = context;
  }

  static setContentNode(node: ComponentContent<Object>) {
    PrivacyDialog.contentNode = node;
  }

  static setOptions(options: promptAction.BaseDialogOptions) {
    PrivacyDialog.options = options;
  }

  static openDialog() {
    if (PrivacyDialog.contentNode !== null) {
      PrivacyDialog.ctx.getPromptAction().openCustomDialog(PrivacyDialog.contentNode, PrivacyDialog.options)
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
    if (PrivacyDialog.contentNode !== null) {
      PrivacyDialog.ctx.getPromptAction().closeCustomDialog(PrivacyDialog.contentNode)
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
    if (PrivacyDialog.contentNode !== null) {
      PrivacyDialog.ctx.getPromptAction().updateCustomDialog(PrivacyDialog.contentNode, options)
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