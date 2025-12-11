import { addBookmark, Bookmark, cancelBookmark, getBookmark } from 'bookmark';
import { PrefConst } from 'constants';
import { YmdHisToNumber } from 'utils';

class ClassicPoemViewModel {
  getBookmark(id: number): Promise<Bookmark | undefined> {
    return getBookmark(id, PrefConst.CLASSICALLITERATURE_CLASSICPOEM)
      .then((value: Bookmark | undefined) => {
        return value
      })
      .catch(() => {
        return undefined
      })
  }

  addBookmark(id: number): Promise<Bookmark | undefined> {
    return addBookmark(new Bookmark(YmdHisToNumber(), id, PrefConst.CLASSICALLITERATURE_CLASSICPOEM))
      .then(() => {
        return getBookmark(id, PrefConst.CLASSICALLITERATURE_CLASSICPOEM)
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
    return cancelBookmark(id, PrefConst.CLASSICALLITERATURE_CLASSICPOEM)
  }
}

export default new ClassicPoemViewModel();