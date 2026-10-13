import { BusinessError } from '@kit.BasicServicesKit';
import { ComponentContent, promptAction } from '@kit.ArkUI';
import { UIContext } from '@ohos.arkui.UIContext';

//题库的删除按钮
export class DeleteDialog {
  static ctx: UIContext;
  static contentNode: ComponentContent<Object>;
  static options: promptAction.BaseDialogOptions;

  static setContext(context: UIContext) {
    DeleteDialog.ctx = context;
  }

  static setContentNode(node: ComponentContent<Object>) {
    DeleteDialog.contentNode = node;
  }

  static setOptions(options: promptAction.BaseDialogOptions) {
    DeleteDialog.options = options;
  }

  static openDialog() {
    if (DeleteDialog.contentNode !== null) {
      DeleteDialog.ctx.getPromptAction().openCustomDialog(DeleteDialog.contentNode, DeleteDialog.options)
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
    if (DeleteDialog.contentNode !== null) {
      DeleteDialog.ctx.getPromptAction().closeCustomDialog(DeleteDialog.contentNode)
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
    if (DeleteDialog.contentNode !== null) {
      DeleteDialog.ctx.getPromptAction().updateCustomDialog(DeleteDialog.contentNode, options)
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