export interface Node {
  file: string,
  children?: ReadonlyArray<Node>;
}

export interface Var {
  name: string,
  value: string
}