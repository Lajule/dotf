import {FC} from 'react';

interface VariablesProps {
  variables: {[key: string]: any}
}

export const Variables: FC<VariablesProps> = ({ variables }) => {
  return (
    <form>
      {Object.keys(variables).map((name, i) => (
        <div key={name + i}>
          <label htmlFor={name}>{name}: </label>
          <input type="text" name={name} id={name} value={variables[name]} readOnly />
        </div>
      ))}
    </form>
  );
}
