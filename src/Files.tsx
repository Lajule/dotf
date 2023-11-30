import {FC} from 'react';

interface FilesProps {
  files: ReadonlyArray<string>,
  onSelected: (index: number) => void
}

export const Files: FC<FilesProps> = ({ files, onSelected }) => {
  return (
    <ul>
      {files.map((file, i) => (
        <li key={file + i}>
          <button onClick={() => onSelected(i)}>{file}</button>
        </li>
      ))}
    </ul>
  );
}
