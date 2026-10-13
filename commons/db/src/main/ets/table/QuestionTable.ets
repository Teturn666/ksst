import ChRdb from '../ChRdb';
import DbConstants from '../constants/DbConstants';
import { relationalStore } from '@kit.ArkData';
import { QuestionRes } from '../model/QuestionRes';
import { Logger } from 'utils';

//题目表
class QuestionTable {
  private accountTable = new ChRdb(DbConstants.QUESTION_TABLE.tableName, DbConstants.QUESTION_TABLE.sqlCreate,
    DbConstants.QUESTION_TABLE.columns);

  constructor(callback: Function = () => {
  }) {
    this.accountTable.getRdbStore(callback);
  }

  getRdbStore(callback: Function = () => {
  }) {
    this.accountTable.getRdbStore(callback);
  }

  insertData(account: QuestionRes, callback: Function) {
    const valueBucket: relationalStore.ValuesBucket = generateBucket(account);
    this.accountTable.insertData(valueBucket, callback);
  }

  async insertDataAwait(account: QuestionRes) {
    const valueBucket: relationalStore.ValuesBucket = generateBucket(account);
    return await this.accountTable.insertDataAwait(valueBucket);
  }

  deleteData(account: QuestionRes, callback: Function) {
    let predicates = new relationalStore.RdbPredicates(DbConstants.QUESTION_TABLE.tableName);
    predicates.equalTo('qId', account.qId);
    this.accountTable.deleteData(predicates, callback);
  }

  updateData(account: QuestionRes, callback: Function) {
    const valueBucket: relationalStore.ValuesBucket = generateBucket(account);
    let predicates = new relationalStore.RdbPredicates(DbConstants.QUESTION_TABLE.tableName);
    predicates.equalTo('id', account.qId);
    this.accountTable.updateData(predicates, valueBucket, callback);
  }

  query(amount: number, callback: Function, isAll: boolean = true) {
    let predicates = new relationalStore.RdbPredicates(DbConstants.QUESTION_TABLE.tableName);
    if (!isAll) {
      predicates.equalTo('id', amount);
    }
    this.accountTable.query(predicates, (resultSet: relationalStore.ResultSet) => {
      let count: number = resultSet.rowCount;
      if (count === 0 || typeof count === 'string') {
        console.log(`${DbConstants.TABLE_TAG}` + 'Query no results!');
        callback([]);
      } else {
        resultSet.goToFirstRow();
        const result: QuestionRes[] = [];
        for (let i = 0; i < count; i++) {
          let tmp: QuestionRes = {
            // id: 0,
            qId: 0,
            question: '',
            answer: '',
            option: [],
            wrongAnswer: '',
            questionID:0,
          };
          // tmp.id = resultSet.getDouble(resultSet.getColumnIndex('id'));
          tmp.qId = resultSet.getDouble(resultSet.getColumnIndex('qId'));
          tmp.question = resultSet.getString(resultSet.getColumnIndex('question'));
          tmp.answer = resultSet.getString(resultSet.getColumnIndex('answer'));
          tmp.option = resultSet.getString(resultSet.getColumnIndex('option')).split(DbConstants.SEPARATOR);
          tmp.questionID = resultSet.getDouble(resultSet.getColumnIndex('questionID'));
          result[i] = tmp;
          resultSet.goToNextRow();
        }
        callback(result);
      }
    });
  }

  async querySync(id: number, isAll: boolean = true): Promise<Array<QuestionRes>> {
    let predicates = new relationalStore.RdbPredicates(DbConstants.QUESTION_TABLE.tableName);
    if (!isAll) {
      predicates.equalTo('qId', id);
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
          const result: QuestionRes[] = [];
          for (let i = 0; i < count; i++) {
            let tmp: QuestionRes = {
              // id: 0,
              qId: 0,
              question: '',
              answer: '',
              option: [],
              wrongAnswer: '',
              questionID:0
            };
            // tmp.id = resultSet.getDouble(resultSet.getColumnIndex('id'));
            tmp.qId = resultSet.getDouble(resultSet.getColumnIndex('qId'));
            tmp.question = resultSet.getString(resultSet.getColumnIndex('question'));
            tmp.answer = resultSet.getString(resultSet.getColumnIndex('answer'));
            tmp.option = resultSet.getString(resultSet.getColumnIndex('option')).split(DbConstants.SEPARATOR);
            tmp.questionID = resultSet.getDouble(resultSet.getColumnIndex('questionID'));
            result[i] = tmp;
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

function generateBucket(account: QuestionRes): relationalStore.ValuesBucket {
  let obj: relationalStore.ValuesBucket = {};
  obj.qId = account.qId;
  obj.question = account.question;
  obj.answer = account.answer;
  obj.option = (account.option ?? []).join(DbConstants.SEPARATOR)
  obj.questionID = account.questionID;
  return obj;
}

export const questionTable = new QuestionTable()