import {FC} from 'react';
import {Var} from './types';

interface FormVarProps {
  variables: ReadonlyArray<Var>;
}

export const FormVar: FC<FormVarProps> = ({ variables }) => {
  return (
    <table>
    </table>
  );
}
