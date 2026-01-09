import { addBookmark, Bookmark, cancelBookmark, getBookmark } from 'bookmark';
import { PrefConst } from 'constants';
import { YmdHisToNumber } from 'utils';
import { getPeople, getRandomPeople, People, search } from '../model/People';

class PeopleViewModel {
  getBookmark(id: number): Promise<Bookmark | undefined> {
    return getBookmark(id, PrefConst.CLASSICALLITERATURE_PEOPLE)
      .then((value: Bookmark | undefined) => {
        return value
      })
      .catch(() => {
        return undefined
      })
  }

  addBookmark(id: number): Promise<Bookmark | undefined> {
    return addBookmark(new Bookmark(YmdHisToNumber(), id, PrefConst.CLASSICALLITERATURE_PEOPLE))
      .then(() => {
        return getBookmark(id, PrefConst.CLASSICALLITERATURE_PEOPLE)
          .then((value: Bookmark | undefined) => {
            return value
          })
          .catch(() => {
            return undefined
          })
      })
      .catch(() => {
        return undefined
      })
  }

  cancelBookmark(id: number): Promise<number | undefined> {
    return cancelBookmark(id, PrefConst.CLASSICALLITERATURE_PEOPLE)
  }

  getRandomPeople(): Promise<People | undefined> {
    return getRandomPeople();
  }

  getPeople(id: number): Promise<People | undefined> {
    return getPeople(id);
  }

  search(query: string): Promise<People[]> {
    return search(query);
  }

  /*getBookmarks(): Promise<People[]>{
    return getBookmarks();
  }*/
}

export default new PeopleViewModel();