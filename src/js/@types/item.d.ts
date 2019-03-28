export interface Item {
  id: number;
  deleted?: boolean;
  type?: 'job' | 'story' | 'comment' | 'poll' | 'pollopt';
  by?: string;
  time?: Date;
  text?: string;
  dead?: boolean;
  parent?: number;
  poll?: number;
  kids?: number[] | Item[];
  url?: string;
  score?: number;
  title?: string;
  parts?: number[];
  descendants?: number;
}
