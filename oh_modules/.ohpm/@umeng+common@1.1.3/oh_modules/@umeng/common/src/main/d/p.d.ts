import dataPreferences from '@ohos.data.preferences';
import common from '@ohos.app.ability.common';
export declare class ConfigStore {
    private static preferences;
    private static interval;
    private static init;
    static getInstance(k12: common.ApplicationContext, l12?: string): dataPreferences.Preferences;
}
