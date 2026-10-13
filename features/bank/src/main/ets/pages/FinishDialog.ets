import { BusinessError } from '@kit.BasicServicesKit';
import { ComponentContent, promptAction } from '@kit.ArkUI';
import { UIContext } from '@ohos.arkui.UIContext';

export class FinishDialog {
  static ctx: UIContext;
  static contentNode: ComponentContent<Object>;
  static options: promptAction.BaseDialogOptions;

  static setContext(context: UIContext) {
    FinishDialog.ctx = context;
  }

  static setContentNode(node: ComponentContent<Object>) {
    FinishDialog.contentNode = node;
  }

  static setOptions(options: promptAction.BaseDialogOptions) {
    FinishDialog.options = options;
  }

  static openDialog() {
    if (FinishDialog.contentNode !== null) {
      FinishDialog.ctx.getPromptAction().openCustomDialog(FinishDialog.contentNode, FinishDialog.options)
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
    if (FinishDialog.contentNode !== null) {
      FinishDialog.ctx.getPromptAction().closeCustomDialog(FinishDialog.contentNode)
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
    if (FinishDialog.contentNode !== null) {
      FinishDialog.ctx.getPromptAction().updateCustomDialog(FinishDialog.contentNode, options)
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