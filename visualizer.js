/**
 * AAA Graph Algorithms Visualizer Engine — High-DPI HD Rendering & Spacious Graph Layouts
 */

let currentAlgo = 'dark_roads';
let isPlaying = false;
let playInterval = null;
let currentStepIndex = 0;
let animationSteps = [];
let animSpeed = 500;

let canvas, ctx;
let dpr = 1;

// --- Presets Data ---
const PRESETS = {
  dark_roads: [
    { label: "Sample (4 Nodes, 5 Edges)", text: "4 5\n0 1 1\n1 2 1\n0 2 1\n2 3 2\n0 3 100" },
    { label: "Sample (7 Nodes, 11 Edges)", text: "7 11\n0 1 7\n0 3 5\n1 2 8\n1 3 9\n1 4 7\n2 4 5\n3 4 15\n3 5 6\n4 5 8\n4 6 9\n5 6 11" },
    { label: "Multiple Edges (3 Nodes, 5 Edges)", text: "3 5\n0 1 10\n0 1 1\n1 2 20\n1 2 2\n0 2 100" },
    { label: "Dense Graph (10 Nodes, 15 Edges)", text: "10 15\n0 1 4\n0 7 8\n1 2 8\n1 7 11\n2 3 7\n2 8 2\n2 5 4\n3 4 9\n3 5 14\n4 5 10\n5 6 2\n6 7 1\n6 8 6\n7 8 7\n8 9 3" },
    { label: "Cyclic Graph (8 Nodes, 12 Edges)", text: "8 12\n0 1 3\n1 2 5\n2 3 2\n3 4 7\n4 5 1\n5 6 4\n6 7 6\n7 0 8\n0 2 12\n1 3 15\n4 6 9\n5 7 10" }
  ],
  knight_in_war: [
    { label: "6x6 Grid (M=1, N=3, 4 Water)", text: "6 6\n1 3\n4\n0 1\n0 2\n0 3\n0 4" },
    { label: "5x5 Grid (M=2, N=2, 4 Water)", text: "5 5\n2 2\n4\n0 2\n2 0\n2 4\n4 2" },
    { label: "7x7 Grid (M=2, N=3, 4 Water)", text: "7 7\n2 3\n4\n0 1\n0 2\n2 2\n3 3" },
    { label: "10x10 Grid (M=1, N=2, 8 Water)", text: "10 10\n1 2\n8\n1 1\n2 2\n3 3\n4 4\n5 5\n6 6\n7 7\n8 8" },
    { label: "12x12 Grid (M=2, N=4, 6 Water)", text: "12 12\n2 4\n6\n0 2\n2 0\n4 4\n6 6\n8 8\n10 10" }
  ],
  play_on_words: [
    { label: "4 Words (Disconnected)", text: "4\nab\nba\ncd\ndc" },
    { label: "2 Words (Degree Imbalanced)", text: "2\nab\nab" },
    { label: "5 Words (Eulerian Path Valid)", text: "5\nab\nbc\ncd\nda\nae" },
    { label: "8 Words (Eulerian Circuit)", text: "8\napple\nelement\ntiger\nrabbit\ntrain\nnest\ntail\nllama" },
    { label: "7 Words (Multi-component)", text: "7\nalpha\nalpha\nbeta\nbeta\ngamma\ngamma\ndelta" }
  ]
};

const INPUT_HINTS = {
  dark_roads: "Format:\nLine 1: m n (junctions roads)\nNext n lines: u v w (from to cost)",
  knight_in_war: "Format:\nLine 1: R C (grid rows cols)\nLine 2: M N (knight jump offsets)\nLine 3: W (number of water cells)\nNext W lines: r c (water cell coordinates)",
  play_on_words: "Format:\nLine 1: N (number of words)\nNext N lines: word"
};

document.addEventListener('DOMContentLoaded', () => {
  canvas = document.getElementById('vizCanvas');
  ctx = canvas.getContext('2d');

  resizeCanvas();
  window.addEventListener('resize', resizeCanvas);

  setupEventListeners();
  switchAlgo('dark_roads');
});

function resizeCanvas() {
  const container = canvas.parentElement;
  dpr = window.devicePixelRatio || 1;
  const width = container.clientWidth;
  const height = container.clientHeight;

  canvas.width = width * dpr;
  canvas.height = height * dpr;
  canvas.style.width = `${width}px`;
  canvas.style.height = `${height}px`;

  ctx.resetTransform();
  ctx.scale(dpr, dpr);

  if (animationSteps.length > 0) {
    renderStep(currentStepIndex);
  }
}

function setupEventListeners() {
  document.querySelectorAll('.tab-btn').forEach(btn => {
    btn.addEventListener('click', () => {
      document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
      btn.classList.add('active');
      switchAlgo(btn.dataset.algo);
    });
  });

  document.getElementById('playPauseBtn').addEventListener('click', togglePlay);
  document.getElementById('stepPrevBtn').addEventListener('click', stepPrev);
  document.getElementById('stepNextBtn').addEventListener('click', stepNext);
  document.getElementById('resetBtn').addEventListener('click', resetViz);

  document.getElementById('speedSlider').addEventListener('input', (e) => {
    animSpeed = 2100 - parseInt(e.target.value);
    if (isPlaying) { pause(); play(); }
  });

  document.getElementById('presetSelect').addEventListener('change', (e) => {
    loadPreset(parseInt(e.target.value));
  });

  const modal = document.getElementById('inputModal');
  document.getElementById('openInputBtn').addEventListener('click', () => {
    document.getElementById('customInputArea').value = PRESETS[currentAlgo][0].text;
    document.getElementById('inputHint').innerText = INPUT_HINTS[currentAlgo];
    modal.classList.add('active');
  });

  document.getElementById('closeModalBtn').addEventListener('click', () => modal.classList.remove('active'));

  document.getElementById('applyInputBtn').addEventListener('click', () => {
    const rawText = document.getElementById('customInputArea').value.trim();
    if (parseAndVisualizeCustomInput(rawText)) modal.classList.remove('active');
  });
}

function switchAlgo(algoKey) {
  pause();
  currentAlgo = algoKey;
  populatePresets(algoKey);
  loadPreset(0);
}

function populatePresets(algoKey) {
  document.getElementById('presetSelect').innerHTML = PRESETS[algoKey]
    .map((p, idx) => `<option value="${idx}">${p.label}</option>`)
    .join('');
}

function loadPreset(idx) {
  pause();
  parseAndVisualizeCustomInput(PRESETS[currentAlgo][idx].text);
}

function parseAndVisualizeCustomInput(text) {
  const lines = text.split('\n').map(l => l.trim()).filter(l => l.length > 0);
  try {
    if (currentAlgo === 'dark_roads') {
      const [m, n] = lines[0].split(/\s+/).map(Number);
      const edges = [];
      for (let i = 1; i <= n && i < lines.length; i++) {
        const [u, v, w] = lines[i].split(/\s+/).map(Number);
        edges.push([u, v, w]);
      }
      animationSteps = generateDarkRoadsSteps({ n: m, edges });
    } else if (currentAlgo === 'knight_in_war') {
      const [R, C] = lines[0].split(/\s+/).map(Number);
      const [M, N] = lines[1].split(/\s+/).map(Number);
      const W = parseInt(lines[2]);
      const water = [];
      for (let i = 3; i < 3 + W && i < lines.length; i++) {
        const [r, c] = lines[i].split(/\s+/).map(Number);
        water.push([r, c]);
      }
      animationSteps = generateKnightInWarSteps({ R, C, M, N, water });
    } else if (currentAlgo === 'play_on_words') {
      const N = parseInt(lines[0]);
      const words = lines.slice(1, 1 + N);
      animationSteps = generatePlayOnWordsSteps({ words });
    }

    currentStepIndex = 0;
    renderStep(0);
    return true;
  } catch (err) {
    alert("Invalid input format.");
    return false;
  }
}

// --- Playback Controls ---
function togglePlay() { if (isPlaying) pause(); else play(); }

function play() {
  if (currentStepIndex >= animationSteps.length - 1) currentStepIndex = 0;
  isPlaying = true;
  document.getElementById('playPauseBtn').innerHTML = '<span>⏸</span> Pause';
  playInterval = setInterval(() => {
    if (currentStepIndex < animationSteps.length - 1) {
      currentStepIndex++;
      renderStep(currentStepIndex);
    } else pause();
  }, animSpeed);
}

function pause() {
  isPlaying = false;
  document.getElementById('playPauseBtn').innerHTML = '<span>▶</span> Play';
  if (playInterval) clearInterval(playInterval);
}

function stepNext() {
  pause();
  if (currentStepIndex < animationSteps.length - 1) {
    currentStepIndex++;
    renderStep(currentStepIndex);
  }
}

function stepPrev() {
  pause();
  if (currentStepIndex > 0) {
    currentStepIndex--;
    renderStep(currentStepIndex);
  }
}

function resetViz() {
  pause();
  currentStepIndex = 0;
  renderStep(0);
}

function renderStep(idx) {
  const step = animationSteps[idx];
  if (!step) return;

  updateStatsBanner(step.stats || {});

  if (currentAlgo === 'dark_roads') drawDarkRoads(step);
  else if (currentAlgo === 'knight_in_war') drawKnightInWar(step);
  else if (currentAlgo === 'play_on_words') drawPlayOnWords(step);
}

function updateStatsBanner(stats) {
  document.getElementById('statsBanner').innerHTML = Object.entries(stats)
    .map(([k, v]) => `
      <div class="stat-chip">
        <span class="label">${k}</span>
        <span class="value">${v}</span>
      </div>
    `).join('');
}

// ============================================================================
// 1. Dark Roads — HD Spacious Graph Renderer
// ============================================================================
function generateDarkRoadsSteps(data) {
  const steps = [];
  const { n, edges } = data;

  const width = canvas.width / (dpr || 1);
  const height = canvas.height / (dpr || 1);
  const cx = width / 2, cy = height / 2;
  const radius = Math.min(width, height) * 0.36;

  const nodePositions = [];
  for (let i = 0; i < n; i++) {
    const angle = (2 * Math.PI * i) / n - Math.PI / 2;
    nodePositions.push({ x: cx + radius * Math.cos(angle), y: cy + radius * Math.sin(angle) });
  }

  const sortedEdges = [...edges].sort((a, b) => a[2] - b[2]);
  const totalCost = edges.reduce((acc, e) => acc + e[2], 0);

  steps.push({
    stats: { "Total Cost": totalCost, "MST Cost": 0, "Max Savings": 0 },
    nodePositions, edges: sortedEdges.map(e => ({ u: e[0], v: e[1], w: e[2], status: 'default' })),
    dsuParents: Array.from({ length: n }, (_, i) => i)
  });

  const parent = Array.from({ length: n }, (_, i) => i);
  function find(x) {
    if (parent[x] !== x) parent[x] = find(parent[x]);
    return parent[x];
  }
  function unite(a, b) {
    const ra = find(a), rb = find(b);
    if (ra === rb) return false;
    parent[rb] = ra;
    return true;
  }

  let mstCost = 0;
  const edgeStatuses = sortedEdges.map(e => ({ u: e[0], v: e[1], w: e[2], status: 'default' }));

  sortedEdges.forEach((e, idx) => {
    const [u, v, w] = e;
    edgeStatuses[idx].status = 'inspecting';
    steps.push({
      stats: { "Total Cost": totalCost, "MST Cost": mstCost, "Savings": totalCost - mstCost },
      nodePositions, edges: edgeStatuses.map(item => ({ ...item })), dsuParents: [...parent]
    });

    if (unite(u, v)) {
      mstCost += w;
      edgeStatuses[idx].status = 'accepted';
    } else {
      edgeStatuses[idx].status = 'rejected';
    }

    steps.push({
      stats: { "Total Cost": totalCost, "MST Cost": mstCost, "Savings": totalCost - mstCost },
      nodePositions, edges: edgeStatuses.map(item => ({ ...item })), dsuParents: [...parent]
    });
  });

  return steps;
}

function drawDarkRoads(step) {
  const width = canvas.width / dpr;
  const height = canvas.height / dpr;
  ctx.clearRect(0, 0, width, height);

  const { nodePositions, edges, dsuParents } = step;
  const palette = ['#4f46e5', '#0284c7', '#059669', '#d97706', '#dc2626', '#7c3aed', '#db2777'];

  function findRoot(x) {
    let curr = x;
    while (dsuParents[curr] !== curr) curr = dsuParents[curr];
    return curr;
  }

  // Draw Edges
  edges.forEach(e => {
    const p1 = nodePositions[e.u];
    const p2 = nodePositions[e.v];

    ctx.beginPath();
    ctx.moveTo(p1.x, p1.y);
    ctx.lineTo(p2.x, p2.y);

    if (e.status === 'inspecting') {
      ctx.strokeStyle = '#f59e0b'; ctx.lineWidth = 5; ctx.setLineDash([]);
    } else if (e.status === 'accepted') {
      ctx.strokeStyle = '#10b981'; ctx.lineWidth = 4.5; ctx.setLineDash([]);
    } else if (e.status === 'rejected') {
      ctx.strokeStyle = '#cbd5e1'; ctx.lineWidth = 2; ctx.setLineDash([6, 6]);
    } else {
      ctx.strokeStyle = '#e2e8f0'; ctx.lineWidth = 2.5; ctx.setLineDash([]);
    }
    ctx.stroke();
    ctx.setLineDash([]);

    // Edge Weight Pill
    const mx = (p1.x + p2.x) / 2;
    const my = (p1.y + p2.y) / 2;

    ctx.save();
    ctx.shadowColor = 'rgba(0, 0, 0, 0.08)';
    ctx.shadowBlur = 6;
    ctx.fillStyle = '#ffffff';
    ctx.beginPath();
    ctx.arc(mx, my, 15, 0, 2 * Math.PI);
    ctx.fill();
    ctx.restore();

    ctx.strokeStyle = e.status === 'accepted' ? '#10b981' : e.status === 'inspecting' ? '#f59e0b' : '#cbd5e1';
    ctx.lineWidth = 1.8;
    ctx.stroke();

    ctx.fillStyle = e.status === 'accepted' ? '#065f46' : '#1e293b';
    ctx.font = '700 12px Inter';
    ctx.textAlign = 'center'; ctx.textBaseline = 'middle';
    ctx.fillText(e.w, mx, my);
  });

  // Draw Nodes
  nodePositions.forEach((pos, idx) => {
    const root = findRoot(idx);
    const color = palette[root % palette.length];

    ctx.save();
    ctx.shadowColor = 'rgba(0, 0, 0, 0.1)';
    ctx.shadowBlur = 10;
    ctx.beginPath();
    ctx.arc(pos.x, pos.y, 28, 0, 2 * Math.PI);
    ctx.fillStyle = '#ffffff';
    ctx.fill();
    ctx.restore();

    ctx.strokeStyle = color;
    ctx.lineWidth = 4;
    ctx.stroke();

    ctx.fillStyle = '#0f172a';
    ctx.font = '800 16px Inter';
    ctx.textAlign = 'center'; ctx.textBaseline = 'middle';
    ctx.fillText(idx, pos.x, pos.y);
  });
}

// ============================================================================
// 2. Knight in a War Grid — HD Renderer
// ============================================================================
function generateKnightInWarSteps(data) {
  const steps = [];
  const { R, C, M, N, water } = data;

  const deltasSet = new Set();
  for (const sm of [1, -1]) {
    for (const sn of [1, -1]) {
      deltasSet.add(`${sm * M},${sn * N}`);
      deltasSet.add(`${sm * N},${sn * M}`);
    }
  }
  const deltas = Array.from(deltasSet).map(s => s.split(',').map(Number));

  const waterGrid = Array.from({ length: R }, () => Array(C).fill(false));
  water.forEach(([r, c]) => {
    if (r >= 0 && r < R && c >= 0 && c < C) waterGrid[r][c] = true;
  });

  const visited = Array.from({ length: R }, () => Array(C).fill(false));

  steps.push({
    stats: { "Reachable": 0, "Even": 0, "Odd": 0 },
    R, C, waterGrid, visited: Array.from({ length: R }, () => Array(C).fill(false)),
    currentCell: null, cellParities: {}
  });

  if (waterGrid[0][0]) return steps;

  visited[0][0] = true;
  const queue = [[0, 0]];
  const reachable = [];

  while (queue.length > 0) {
    const [r, c] = queue.shift();
    reachable.push([r, c]);

    steps.push({
      stats: { "Reachable": reachable.length, "Even": 0, "Odd": 0 },
      R, C, waterGrid, visited: visited.map(row => [...row]),
      currentCell: [r, c], cellParities: {}
    });

    for (const [dr, dc] of deltas) {
      const nr = r + dr, nc = c + dc;
      if (nr >= 0 && nr < R && nc >= 0 && nc < C && !waterGrid[nr][nc] && !visited[nr][nc]) {
        visited[nr][nc] = true;
        queue.push([nr, nc]);
      }
    }
  }

  let evenCount = 0, oddCount = 0;
  const cellParities = {};
  reachable.forEach(([r, c]) => {
    let neighbors = 0;
    deltas.forEach(([dr, dc]) => {
      const nr = r + dr, nc = c + dc;
      if (nr >= 0 && nr < R && nc >= 0 && nc < C && !waterGrid[nr][nc] && visited[nr][nc]) neighbors++;
    });

    const isEven = (neighbors % 2 === 0);
    if (isEven) evenCount++; else oddCount++;
    cellParities[`${r},${c}`] = { cnt: neighbors, isEven };
  });

  steps.push({
    stats: { "Reachable": reachable.length, "Even": evenCount, "Odd": oddCount },
    R, C, waterGrid, visited: visited.map(row => [...row]),
    currentCell: null, cellParities
  });

  return steps;
}

function drawKnightInWar(step) {
  const width = canvas.width / dpr;
  const height = canvas.height / dpr;
  ctx.clearRect(0, 0, width, height);

  const { R, C, waterGrid, visited, currentCell, cellParities } = step;

  const padding = 24;
  const cellSize = Math.min((width - 2 * padding) / C, (height - 2 * padding) / R);
  const offsetX = (width - C * cellSize) / 2;
  const offsetY = (height - R * cellSize) / 2;

  for (let r = 0; r < R; r++) {
    for (let c = 0; c < C; c++) {
      const x = offsetX + c * cellSize;
      const y = offsetY + r * cellSize;

      ctx.beginPath();
      ctx.roundRect(x, y, cellSize - 4, cellSize - 4, 6);

      const key = `${r},${c}`;
      if (waterGrid[r][c]) {
        ctx.fillStyle = '#bae6fd';
      } else if (currentCell && currentCell[0] === r && currentCell[1] === c) {
        ctx.fillStyle = '#818cf8';
      } else if (cellParities[key]) {
        ctx.fillStyle = cellParities[key].isEven ? '#a7f3d0' : '#fde68a';
      } else if (visited[r][c]) {
        ctx.fillStyle = '#e0e7ff';
      } else {
        ctx.fillStyle = '#ffffff';
      }

      ctx.fill();
      ctx.strokeStyle = '#cbd5e1';
      ctx.lineWidth = 1.5;
      ctx.stroke();

      ctx.fillStyle = '#0f172a';
      ctx.font = `700 ${Math.max(12, cellSize * 0.35)}px Inter`;
      ctx.textAlign = 'center'; ctx.textBaseline = 'middle';

      if (waterGrid[r][c]) ctx.fillText('🌊', x + cellSize / 2, y + cellSize / 2);
      else if (r === 0 && c === 0) ctx.fillText('♞', x + cellSize / 2, y + cellSize / 2);
      else if (cellParities[key]) ctx.fillText(`${cellParities[key].cnt}`, x + cellSize / 2, y + cellSize / 2);
    }
  }
}

// ============================================================================
// 3. Play on Words — HD Curved Bezier Directed Graph Renderer
// ============================================================================
function generatePlayOnWordsSteps(data) {
  const steps = [];
  const { words } = data;

  const usedLetters = new Set();
  const inDeg = {}, outDeg = {};
  words.forEach(w => {
    const u = w[0], v = w[w.length - 1];
    usedLetters.add(u); usedLetters.add(v);
    inDeg[u] = 0; inDeg[v] = 0; outDeg[u] = 0; outDeg[v] = 0;
  });

  const activeLetters = Array.from(usedLetters).sort();
  const parent = {};
  activeLetters.forEach(l => parent[l] = l);

  function find(x) {
    if (parent[x] !== x) parent[x] = find(parent[x]);
    return parent[x];
  }
  function unite(a, b) {
    const ra = find(a), rb = find(b);
    if (ra !== rb) parent[rb] = ra;
  }

  const width = canvas.width / (dpr || 1);
  const height = canvas.height / (dpr || 1);
  const cx = width / 2, cy = height / 2;
  const radius = Math.min(width, height) * 0.36;

  const nodePositions = {};
  activeLetters.forEach((l, idx) => {
    const angle = (2 * Math.PI * idx) / activeLetters.length - Math.PI / 2;
    nodePositions[l] = { x: cx + radius * Math.cos(angle), y: cy + radius * Math.sin(angle) };
  });

  steps.push({
    stats: { "Words": words.length, "Letters": activeLetters.length, "Result": "Building Graph" },
    nodePositions, activeLetters, edges: [], inDeg: { ...inDeg }, outDeg: { ...outDeg }, parent: { ...parent }
  });

  const edges = [];
  words.forEach(w => {
    const u = w[0], v = w[w.length - 1];
    outDeg[u]++; inDeg[v]++;
    unite(u, v);
    edges.push({ u, v, label: w });

    steps.push({
      stats: { "Words": edges.length, "Letters": activeLetters.length, "Result": "Building Graph" },
      nodePositions, activeLetters, edges: [...edges], inDeg: { ...inDeg }, outDeg: { ...outDeg }, parent: { ...parent }
    });
  });

  const roots = new Set(activeLetters.map(l => find(l)));
  const isConnected = (roots.size === 1);

  let startNodes = 0, endNodes = 0, badNodes = 0;
  activeLetters.forEach(l => {
    const diff = outDeg[l] - inDeg[l];
    if (diff === 1) startNodes++;
    else if (diff === -1) endNodes++;
    else if (diff !== 0) badNodes++;
  });

  const isValid = isConnected && ((startNodes === 0 && endNodes === 0 && badNodes === 0) || (startNodes === 1 && endNodes === 1 && badNodes === 0));

  steps.push({
    stats: { "Connected": isConnected ? "YES" : "NO", "Start/End": `${startNodes}/${endNodes}`, "Result": isValid ? "POSSIBLE" : "IMPOSSIBLE" },
    nodePositions, activeLetters, edges: [...edges], inDeg: { ...inDeg }, outDeg: { ...outDeg }, parent: { ...parent }
  });

  return steps;
}

function drawPlayOnWords(step) {
  const width = canvas.width / dpr;
  const height = canvas.height / dpr;
  ctx.clearRect(0, 0, width, height);

  const { nodePositions, activeLetters, edges, inDeg, outDeg } = step;

  // Track edge multiplicity to curve overlapping directed edges
  const pairCounts = {};
  edges.forEach(e => {
    const key = `${e.u}->${e.v}`;
    pairCounts[key] = (pairCounts[key] || 0) + 1;
  });

  const pairIndex = {};

  // Draw Directed Edges with Quadratic Curves & Arrowheads
  edges.forEach(e => {
    const p1 = nodePositions[e.u];
    const p2 = nodePositions[e.v];

    const key = `${e.u}->${e.v}`;
    const reverseKey = `${e.v}->${e.u}`;
    const idx = pairIndex[key] || 0;
    pairIndex[key] = idx + 1;

    const isSelfLoop = (e.u === e.v);
    const hasReverse = !!pairCounts[reverseKey];

    ctx.beginPath();
    let midX, midY;

    if (isSelfLoop) {
      // Loop arc
      const loopX = p1.x + 40;
      const loopY = p1.y - 40;
      ctx.arc(p1.x + 20, p1.y - 20, 25, 0, 2 * Math.PI);
      midX = loopX; midY = loopY;
    } else {
      // Curve offset calculation
      const dx = p2.x - p1.x;
      const dy = p2.y - p1.y;
      const dist = Math.hypot(dx, dy);

      // Perpendicular normal vector
      const nx = -dy / dist;
      const ny = dx / dist;

      const curvature = (hasReverse || idx > 0) ? (30 + idx * 20) : 0;

      midX = (p1.x + p2.x) / 2 + nx * curvature;
      midY = (p1.y + p2.y) / 2 + ny * curvature;

      ctx.moveTo(p1.x, p1.y);
      if (curvature === 0) {
        ctx.lineTo(p2.x, p2.y);
      } else {
        ctx.quadraticCurveTo(midX, midY, p2.x, p2.y);
      }
    }

    ctx.strokeStyle = '#4f46e5';
    ctx.lineWidth = 2.8;
    ctx.stroke();

    // Calculate Arrowhead Position along curve near target node (r=30)
    const angle = Math.atan2(p2.y - midY, p2.x - midX);
    const arrowLen = 12;
    const targetX = p2.x - 30 * Math.cos(angle);
    const targetY = p2.y - 30 * Math.sin(angle);

    ctx.beginPath();
    ctx.moveTo(targetX, targetY);
    ctx.lineTo(targetX - arrowLen * Math.cos(angle - Math.PI / 6), targetY - arrowLen * Math.sin(angle - Math.PI / 6));
    ctx.lineTo(targetX - arrowLen * Math.cos(angle + Math.PI / 6), targetY - arrowLen * Math.sin(angle + Math.PI / 6));
    ctx.fillStyle = '#4f46e5';
    ctx.fill();

    // Word Badge Label
    ctx.save();
    ctx.shadowColor = 'rgba(0, 0, 0, 0.08)';
    ctx.shadowBlur = 6;
    ctx.fillStyle = '#ffffff';
    ctx.beginPath();
    ctx.roundRect(midX - 22, midY - 12, 44, 24, 6);
    ctx.fill();
    ctx.restore();

    ctx.strokeStyle = '#c7d2fe';
    ctx.lineWidth = 1.5;
    ctx.strokeRect(midX - 22, midY - 12, 44, 24);

    ctx.fillStyle = '#1e1b4b';
    ctx.font = '700 12px Fira Code';
    ctx.textAlign = 'center'; ctx.textBaseline = 'middle';
    ctx.fillText(e.label, midX, midY);
  });

  // Draw Letter Nodes
  activeLetters.forEach(l => {
    const pos = nodePositions[l];

    ctx.save();
    ctx.shadowColor = 'rgba(0, 0, 0, 0.1)';
    ctx.shadowBlur = 10;
    ctx.beginPath();
    ctx.arc(pos.x, pos.y, 30, 0, 2 * Math.PI);
    ctx.fillStyle = '#ffffff';
    ctx.fill();
    ctx.restore();

    ctx.strokeStyle = '#4f46e5';
    ctx.lineWidth = 4;
    ctx.stroke();

    ctx.fillStyle = '#0f172a';
    ctx.font = '800 16px Fira Code';
    ctx.textAlign = 'center'; ctx.textBaseline = 'middle';
    ctx.fillText(l.toUpperCase(), pos.x, pos.y - 4);

    // Degree badge (in/out)
    ctx.fillStyle = '#64748b';
    ctx.font = '600 10px Inter';
    ctx.fillText(`in:${inDeg[l]||0} out:${outDeg[l]||0}`, pos.x, pos.y + 14);
  });
}
