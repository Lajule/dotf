import {useState, useEffect, useCallback} from 'react';
import {saveAs} from 'file-saver';
import Mustache from 'mustache';
import JSZip from 'jszip';
import './App.css';
import {Code} from './Code';
import {Files} from './Files';
import {Variables} from './Variables';

const generateZip = async () => {
  const zip = new JSZip();
  zip.file("Hello.txt", "Hello World\n");

  const content = await zip.generateAsync({type:"blob"});
  saveAs(content, "archive.zip");
}

function App() {
  const [variables, setVariables] = useState({});
  const [files, setFiles] = useState([]);
  const [content, setContent] = useState("");
  const [preview, setPreview] = useState("");

  const fetchVariables = async () => {
    const response = await fetch('variables.json');
    setVariables(await response.json());
  };

  const fetchFiles = async () => {
    const response = await fetch('files.json');
    setFiles(await response.json());
  };

  useEffect(() => {
    fetchVariables();
    fetchFiles();
  }, []);

  useEffect(() => {
    setPreview(Mustache.render(content, variables));
  }, [content, variables]);


  const onSelected = useCallback(async (index: number) => {
    if (files.length > 0) {
      const response = await fetch(encodeURI('/' + files[index]));
      const text = await response.text();
      setContent(text);
    }
  }, [files]);

  return (
    <div className="app">
      <div className="sidebar">
        <div className="files">
          <Files files={files} onSelected={onSelected} />
        </div>
        <div className="toolbar">
          <button onClick={generateZip}>zip</button>
        </div>
      </div>
      <div className="body">
        <div className="variables">
          <Variables variables={variables} />
        </div>
        <div className="file">
          <div className="template">
            <textarea value={content} readOnly></textarea>
          </div>
          <div className="preview">
            <Code content={preview} />
          </div>
        </div>
      </div>
    </div>
  );
}

export default App;
