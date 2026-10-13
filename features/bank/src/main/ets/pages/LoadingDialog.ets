import { BusinessError } from '@kit.BasicServicesKit';
import { ComponentContent, promptAction } from '@kit.ArkUI';
import { UIContext } from '@ohos.arkui.UIContext';

export class LoadingDialog {
  static ctx: UIContext;
  static contentNode: ComponentContent<Object>;
  static options: promptAction.BaseDialogOptions;

  static setContext(context: UIContext) {
    LoadingDialog.ctx = context;
  }

  static setContentNode(node: ComponentContent<Object>) {
    LoadingDialog.contentNode = node;
  }

  static setOptions(options: promptAction.BaseDialogOptions) {
    LoadingDialog.options = options;
  }

  static openDialog() {
    if (LoadingDialog.contentNode !== null) {
      LoadingDialog.ctx.getPromptAction().openCustomDialog(LoadingDialog.contentNode, LoadingDialog.options)
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
    if (LoadingDialog.contentNode !== null) {
      LoadingDialog.ctx.getPromptAction().closeCustomDialog(LoadingDialog.contentNode)
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
    if (LoadingDialog.contentNode !== null) {
      LoadingDialog.ctx.getPromptAction().updateCustomDialog(LoadingDialog.contentNode, options)
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