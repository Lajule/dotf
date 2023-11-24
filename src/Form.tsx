import {FC} from 'react';
import {Variable} from './types';

interface FromProps {
  variables: ReadonlyArray<Variable>;
}

export const Form: FC<FromProps> = ({ variables }) => {
  return (
    <form>
      {variables.map(({name, value}, i) => (
        <div key={name + i}>
          <label htmlFor={name}>{name}: </label>
          <input type="text" name={name} id={name} defaultValue={value} required />
        </div>
      ))}
    </form>
  );
}
