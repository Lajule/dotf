import {FC} from 'react';

interface FilesProps {
  files: ReadonlyArray<string>;
}

export const Files: FC<FilesProps> = ({ files }) => {
  return (
    <ul>
      {files.map((file, i) => (
        <li key={file + i}>
          <button>{file}</button>
        </li>
      ))}
    </ul>
  );
}
