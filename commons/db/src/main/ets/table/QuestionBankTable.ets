import ChRdb from '../ChRdb';
import DbConstants from '../constants/DbConstants';
import { relationalStore } from '@kit.ArkData';
import { BankListRes } from '../model/BankListRes';
import { Logger } from 'utils';

//题库表
class QuestionBankTable {
  private accountTable = new ChRdb(DbConstants.QUESTION_BANK_TABLE.tableName, DbConstants.QUESTION_BANK_TABLE.sqlCreate,
    DbConstants.QUESTION_BANK_TABLE.columns);

  constructor(callback: Function = () => {
  }) {
    this.accountTable.getRdbStore(callback);
  }

  getRdbStore(callback: Function = () => {
  }) {
    this.accountTable.getRdbStore(callback);
  }

  insertData(account: BankListRes, callback: Function) {
    const valueBucket: relationalStore.ValuesBucket = generateBucket(account);
    this.accountTable.insertData(valueBucket, callback);
  }

  /**
   * 异步插入方法
   */
  async insertDataAwait(account: BankListRes): Promise<number> {
    const valueBucket: relationalStore.ValuesBucket = generateBucket(account)
    return await this.accountTable.insertDataAwait(valueBucket)
  }

  deleteData(account: BankListRes, callback: Function) {
    let predicates = new relationalStore.RdbPredicates(DbConstants.QUESTION_BANK_TABLE.tableName);
    predicates.equalTo('qid', account.qid);
    this.accountTable.deleteData(predicates, callback);
  }

  updateData(account: BankListRes, callback: Function) {
    const valueBucket: relationalStore.ValuesBucket = generateBucket(account);
    let predicates = new relationalStore.RdbPredicates(DbConstants.QUESTION_BANK_TABLE.tableName);
    predicates.equalTo('id', account.qid);
    this.accountTable.updateData(predicates, valueBucket, callback);
  }

  async querySync(qid: number, isAll: boolean = true): Promise<Array<BankListRes>> {
    let predicates = new relationalStore.RdbPredicates(DbConstants.QUESTION_BANK_TABLE.tableName);
    if (!isAll) {
      predicates.equalTo('qid', qid);
    }

    let resultSet = await this.accountTable.querySync(predicates)
    if (resultSet == null) {
      return []
    } else {
      try {
        let count: number = resultSet.rowCount;
        if (count === 0 || typeof count === 'string') {
          console.log(`${DbConstants.TABLE_TAG}` + 'Query no results!');
          return []
        } else {
          resultSet.goToFirstRow();
          const result: BankListRes[] = [];
          for (let i = 0; i < count; i++) {
            let tmp: BankListRes = {
              // id: 0,
              qid: 0,
              name: '',
              desc: '',
              time: '',
              url: '',
              num: '',
              version: '',
              position: 0,
              downloadedState: 2
            };
            // tmp.id = resultSet.getDouble(resultSet.getColumnIndex('id'))
            tmp.qid = resultSet.getDouble(resultSet.getColumnIndex('qid'))
            tmp.name = resultSet.getString(resultSet.getColumnIndex('name'))
            // tmp.num = resultSet.getString(resultSet.getColumnIndex('num'))
            tmp.desc = resultSet.getString(resultSet.getColumnIndex('desc'))
            tmp.time = resultSet.getString(resultSet.getColumnIndex('time'))
            tmp.url = resultSet.getString(resultSet.getColumnIndex('url'))
            tmp.version = resultSet.getString(resultSet.getColumnIndex('version'))
            tmp.position = resultSet.getDouble(resultSet.getColumnIndex('position'))
            tmp.downloadedState = resultSet.getDouble(resultSet.getColumnIndex('downloadedState'))
            result[i] = tmp
            resultSet.goToNextRow();
          }
          return result
        }
      } catch (e) {
        Logger.error(e)
        return []
      }
    }
  }
}

function generateBucket(account: BankListRes): relationalStore.ValuesBucket {
  let obj: relationalStore.ValuesBucket = {}
  obj.qid = account.qid
  obj.name = account.name
  obj.desc = account.desc
  obj.time = account.time
  // obj.num = account.num
  obj.url = account.url
  obj.position = account.position
  obj.version = account.version
  obj.downloadedState = account.downloadedState
  return obj;
}

export const questionBankTable = new QuestionBankTable()