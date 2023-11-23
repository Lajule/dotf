export interface Node {
  file: string,
  children?: ReadonlyArray<Node>;
}

export interface Variable {
  name: string,
  value: string
}
