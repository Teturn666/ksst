import { relationalStore } from '@kit.ArkData';
import { DbTableBean } from '../model/DbTableBean';

export default class DbConstants {
  /**
   * Rdb database config.
   */
  static readonly STORE_CONFIG: relationalStore.StoreConfig = {
    name: 'question.db',
    securityLevel: relationalStore.SecurityLevel.S1
  };
  /**
   * Account table config.
   */
  //题库表
  static readonly QUESTION_BANK_TABLE: DbTableBean = {
    tableName: 'questionBank',
    sqlCreate: 'CREATE TABLE IF NOT EXISTS questionBank(id INTEGER PRIMARY KEY AUTOINCREMENT, qid INTEGER, ' +
      'name TEXT,desc TEXT,time TEXT, url TEXT,version TEXT,position INTEGER,downloadedState INTEGER)',
    columns: ['id', 'qid', 'name', 'desc', 'time', 'url', 'version', 'position', 'downloadedState ']
  };
  //题目表
  static readonly QUESTION_TABLE: DbTableBean = {
    tableName: 'question',
    sqlCreate: 'CREATE TABLE IF NOT EXISTS question(id INTEGER PRIMARY KEY AUTOINCREMENT, qId INTEGER, ' +
      'question TEXT, option TEXT, answer TEXT , questionID INTEGER)',
    columns: ['id', 'qId', 'question', 'option', 'answer','questionID']
  };
  //错题题目表
  static readonly QUESTION_WRONG_TABLE: DbTableBean = {
    tableName: 'questionWrong',
    sqlCreate: 'CREATE TABLE IF NOT EXISTS questionWrong(id INTEGER PRIMARY KEY AUTOINCREMENT, qId INTEGER, ' +
      'question TEXT, option TEXT, answer TEXT, wrongAnswer TEXT , questionID INTEGER)',
    columns: ['id', 'qId', 'question', 'option', 'answer', 'wrongAnswer','questionID']
  };
  //收藏题目表
  static readonly QUESTION_COLLECTION_TABLE: DbTableBean = {
    tableName: 'questionCollection',
    sqlCreate: 'CREATE TABLE IF NOT EXISTS questionCollection(id INTEGER PRIMARY KEY AUTOINCREMENT, qId INTEGER, ' +
      'question TEXT, option TEXT, answer TEXT, wrongAnswer TEXT,questionID INTEGER)',
    columns: ['id', 'qId', 'question', 'option', 'answer', 'wrongAnswer,questionID']
  };
  /**
   * Log tag.
   */
  static readonly RDB_TAG = '[Debug.ChRdb]';
  static readonly TABLE_TAG = '[Debug.AccountTable]';
  //选项拼接的间隔符
  static readonly SEPARATOR: string = "~~~"
}
