import { hilog } from '@kit.PerformanceAnalysisKit';

const LOGGER_PREFIX: string = 'JINGMO';

export class Logger {
  private domain: number;
  private prefix: string;
  // format Indicates the log format string.
  private format: string = '%{public}s, %{public}s';

  /**
   * constructor.
   *
   * @param prefix Identifies the log tag.
   * @param domain Indicates the service domain, which is a hexadecimal integer ranging from 0x0 to 0xFFFFF
   * @param args Indicates the log parameters.
   */
  constructor(prefix: string = LOGGER_PREFIX, domain: number = 0xFF00) {
    this.prefix = prefix;
    this.domain = domain;
  }

  debug(...args: string[]): void {
    hilog.debug(this.domain, this.prefix, this.format, args);
  }

  info(...args: string[]): void {
    hilog.info(this.domain, this.prefix, this.format, args);
  }

  warn(...args: string[]): void {
    hilog.warn(this.domain, this.prefix, this.format, args);
  }

  error(...args: string[]): void {
    hilog.error(this.domain, this.prefix, this.format, args);
  }
}

//export default new Logger(LOGGER_PREFIX);