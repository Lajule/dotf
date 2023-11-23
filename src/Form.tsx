import {FC} from 'react';

interface FromProps {
  variables: Map<string, string>;
}

export const Form: FC<FromProps> = ({ variables }) => {
  return (
    <form>
      <div>
        <label htmlFor="foo">foo: </label>
        <input type="text" name="foo" id="foo" required />
      </div>
      <div>
        <label htmlFor="bar">bar: </label>
        <input type="text" name="bar" id="bar" required />
      </div>
    </form>
  );
}
