export interface Config {
  variables: ReadonlyArray<Variable>,
  files: ReadonlyArray<string>
}

export interface Variable {
  name: string,
  value: string
}
