export interface Config {
  variables: ReadonlyArray<Variable>,
  dotfiles: ReadonlyArray<Node>
}

export interface Node {
  file: string,
  children?: ReadonlyArray<Node>
}

export interface Variable {
  name: string,
  value: string
}
