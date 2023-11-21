export interface Node {
  file: string,
  children?: ReadonlyArray<Node>;
}
