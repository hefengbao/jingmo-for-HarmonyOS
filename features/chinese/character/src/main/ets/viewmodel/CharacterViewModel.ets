import { addBookmark, Bookmark, cancelBookmark, getBookmark } from 'bookmark';
import { PrefConst } from 'constants';
import { YmdHisToNumber } from 'utils';

class CharacterViewModel {
  getBookmark(id: number): Promise<Bookmark | undefined> {
    return getBookmark(id, PrefConst.CHINESE_CHARACTER)
      .then((value: Bookmark | undefined) => {
        return value
      })
      .catch(() => {
        return undefined
      })
  }

  addBookmark(id: number): Promise<Bookmark | undefined> {
    return addBookmark(new Bookmark(YmdHisToNumber(), id, PrefConst.CHINESE_CHARACTER))
      .then(() => {
        return getBookmark(id, PrefConst.CHINESE_CHARACTER)
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
    return cancelBookmark(id, PrefConst.CHINESE_CHARACTER)
  }
}

export default new CharacterViewModel();