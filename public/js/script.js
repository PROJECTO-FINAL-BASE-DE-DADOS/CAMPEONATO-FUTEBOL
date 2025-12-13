// --- configuração da página ---
const TABLE_NAME = 'script';
const STORAGE_KEY = 'tbl_' + TABLE_NAME;
const STORAGE_META = STORAGE_KEY + '_meta';

const tbody = document.getElementById('tbody');
const addRowBtn = document.getElementById('addRowBtn');
const clearTableBtn = document.getElementById('clearTableBtn');
const saveBtn = document.getElementById('saveBtn');
const cancelBtn = document.getElementById('cancelBtn');
const emptyMsg = document.getElementById('emptyMsg');
const statusEl = document.getElementById('status');

let snapshot = [];

// Transformar uma linha em chave simples para comparar
function rowsToKey(row) {
  return row.map(v => (v ?? '').trim()).join('§');
}

// Carregar dados da BD
async function loadFromDB() {
  const res = await fetch('/api/rows.php?table=' + encodeURIComponent(TABLE_NAME), { method: 'GET' });
  if (!res.ok) throw new Error('Falha ao carregar da BD');
  const json = await res.json();
  const data = Array.isArray(json.data) ? json.data : [];
  renderTable(data);
  snapshot = structuredClone(data); // estado base vindo da BD
  setStatus('Dados carregados da base de dados');
}

// Enviar apenas linhas novas para a BD
async function addNewRowsToDB(newRows) {
  const res = await fetch('/api/add_rows.php', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ table: TABLE_NAME, data: newRows })
  });
  if (!res.ok) throw new Error('Falha ao inserir na BD');
  return res.json(); // { inserted: n }
}

function updateEmptyState() {
  const hasRows = tbody.querySelectorAll('tr').length > 0;
  emptyMsg.classList.toggle('hidden', hasRows);
}

function createCell(content = '') {
  const td = document.createElement('td');
  td.contentEditable = 'true';
  td.textContent = content;
  return td;
}

function createActionsCell() {
  const td = document.createElement('td');
  td.className = 'row-actions';
  const del = document.createElement('button');
  del.textContent = 'Apagar linha';
  del.className = 'danger';
  del.addEventListener('click', e => {
    const tr = e.target.closest('tr');
    tr.remove();
    updateEmptyState();
  });
  td.appendChild(del);
  return td;
}

function addRow(values = ['', '', '']) {
  const tr = document.createElement('tr');
  tr.appendChild(createCell(values[0]));
  tr.appendChild(createCell(values[1]));
  tr.appendChild(createCell(values[2]));
  tr.appendChild(createActionsCell());
  tbody.appendChild(tr);
  updateEmptyState();
}

function clearTable() {
  if (!confirm('Apagar toda a tabela?')) return;
  tbody.innerHTML = '';
  updateEmptyState();
}

function captureTable() {
  const data = [];
  tbody.querySelectorAll('tr').forEach(tr => {
    const tds = [...tr.querySelectorAll('td')];
    data.push(tds.slice(0, 3).map(td => td.textContent.trim()));
  });
  return data;
}

function renderTable(data = []) {
  tbody.innerHTML = '';
  data.forEach(row => addRow(row));
  updateEmptyState();
}

function downloadJSON(filename, dataObj) {
  const blob = new Blob([JSON.stringify(dataObj, null, 2)], { type: 'application/json' });
  const url = URL.createObjectURL(blob);
  const a = document.createElement('a');
  a.href = url;
  a.download = filename;
  document.body.appendChild(a);
  a.click();
  a.remove();
  URL.revokeObjectURL(url);
}

function setStatus(msg) {
  statusEl.textContent = msg + ' — ' + new Date().toLocaleString();
}

async function save() {
  const data = captureTable();

  // calcular apenas linhas novas: presentes agora mas não no snapshot (BD)
  const snapshotSet = new Set(snapshot.map(rowsToKey));
  const newRows = data.filter(row => !snapshotSet.has(rowsToKey(row)));

  try {
    if (newRows.length > 0) {
      const result = await addNewRowsToDB(newRows);
      // após inserir, atualize o snapshot para refletir o estado atual
      snapshot = structuredClone(data);
      setStatus(`Alterações salvas na BD (novas linhas inseridas: ${result.inserted ?? 0})`);
    } else {
      setStatus('Nenhuma linha nova para salvar na BD');
    }
  } catch (e) {
    setStatus('Falha ao salvar na BD (guardado localmente como rascunho)');
  }

  // backup local/JSON 
  const meta = { savedAt: Date.now() };
  localStorage.setItem(STORAGE_KEY, JSON.stringify(data));
  localStorage.setItem(STORAGE_META, JSON.stringify(meta));
  downloadJSON('tabela-dados.json', { meta, data });
}

function cancel() {
  if (!confirm('Cancelar alterações?')) return;
  renderTable(snapshot);
  setStatus('Alterações canceladas');
}

addRowBtn.addEventListener('click', () => addRow());
clearTableBtn.addEventListener('click', clearTable);
saveBtn.addEventListener('click', save);
cancelBtn.addEventListener('click', cancel);

(async function init() {
  try {
    await loadFromDB(); // prioridade: carregar da base
  } catch (e) {
    // fallback para armazenamento local se a BD falhar/estiver vazia
    try {
      const stored = JSON.parse(localStorage.getItem(STORAGE_KEY) || '[]');
      if (Array.isArray(stored) && stored.length) {
        renderTable(stored);
        snapshot = structuredClone(stored);
        setStatus('Dados carregados do armazenamento local');
      } else {
        addRow(['', '', '']);
        snapshot = captureTable();
        setStatus('Tabela inicializada (vazia)');
      }
    } catch {
      addRow(['', '', '']);
      setStatus('Tabela inicializada (erro ao ler dados locais)');
    }
  }
})();
