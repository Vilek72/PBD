import sqlite3
import tkinter as tk
from tkinter import ttk
from tkinter import messagebox

class DatabaseApp:
    def __init__(self, master):
        self.master = master
        self.master.title("Sistema de Gerenciamento")
        self.master.geometry("1200x700")
        self.master.resizable(True, True)
        
        # Conectar ao banco de dados
        self.conn = sqlite3.connect('empresa.db')
        self.cursor = self.conn.cursor()
        self.create_tables()
        
        # Criar interface
        self.create_widgets()
        self.load_tables()
        
    def create_tables(self):
        try:
            tabelas = [
                '''CREATE TABLE IF NOT EXISTS PessoaFisica (
                    cpf TEXT PRIMARY KEY,
                    nome TEXT)''',
                    
                '''CREATE TABLE IF NOT EXISTS Telefone (
                    cpf_pessoa TEXT,
                    cnpj_empresa TEXT,
                    num_telefone TEXT PRIMARY KEY,
                    FOREIGN KEY(cpf_pessoa) REFERENCES PessoaFisica(cpf))''',
                    
                '''CREATE TABLE IF NOT EXISTS PessoaJuridica (
                    cnpj TEXT PRIMARY KEY,
                    nome TEXT)''',
                    
                '''CREATE TABLE IF NOT EXISTS Fornecedor (
                    id INTEGER PRIMARY KEY,
                    cnpj_empresa TEXT,
                    endereco TEXT,
                    FOREIGN KEY(cnpj_empresa) REFERENCES PessoaJuridica(cnpj))''',
                    
                '''CREATE TABLE IF NOT EXISTS Funcionario (
                    id INTEGER PRIMARY KEY,
                    cpf_func TEXT,
                    FOREIGN KEY(cpf_func) REFERENCES PessoaFisica(cpf))''',
                    
                '''CREATE TABLE IF NOT EXISTS Tecnico (
                    id_func INTEGER PRIMARY KEY,
                    FOREIGN KEY(id_func) REFERENCES Funcionario(id))''',
                    
                '''CREATE TABLE IF NOT EXISTS Vendedor (
                    id_func INTEGER PRIMARY KEY,
                    FOREIGN KEY(id_func) REFERENCES Funcionario(id))''',
                    
                '''CREATE TABLE IF NOT EXISTS Administrador (
                    id_func INTEGER PRIMARY KEY,
                    FOREIGN KEY(id_func) REFERENCES Funcionario(id))''',
                    
                '''CREATE TABLE IF NOT EXISTS Cliente (
                    id_cliente INTEGER PRIMARY KEY,
                    cpf_cliente TEXT,
                    cnpj_cliente TEXT,
                    FOREIGN KEY(cpf_cliente) REFERENCES PessoaFisica(cpf),
                    FOREIGN KEY(cnpj_cliente) REFERENCES PessoaJuridica(cnpj))''',
                    
                '''CREATE TABLE IF NOT EXISTS Pedido (
                    id INTEGER PRIMARY KEY,
                    cpf_cliente TEXT,
                    cnpj_cliente TEXT,
                    id_atendente INTEGER,
                    valor REAL,
                    dataP DATE,
                    FOREIGN KEY(cpf_cliente) REFERENCES PessoaFisica(cpf),
                    FOREIGN KEY(cnpj_cliente) REFERENCES PessoaJuridica(cnpj),
                    FOREIGN KEY(id_atendente) REFERENCES Funcionario(id))''',
                    
                '''CREATE TABLE IF NOT EXISTS ProdutoPedido (
                    id_pedido INTEGER,
                    id_produto INTEGER,
                    quantidade INTEGER,
                    FOREIGN KEY(id_pedido) REFERENCES Pedido(id),
                    FOREIGN KEY(id_produto) REFERENCES ProdutoTipo(id))''',
                    
                '''CREATE TABLE IF NOT EXISTS ProdutoTipo (
                    id INTEGER PRIMARY KEY,
                    id_fornecedor INTEGER,
                    descricao TEXT,
                    FOREIGN KEY(id_fornecedor) REFERENCES Fornecedor(id))''',
                    
                '''CREATE TABLE IF NOT EXISTS ProdutoCliente (
                    id_cliente INTEGER PRIMARY KEY,
                    id_produto INTEGER,
                    id_func INTEGER,
                    data_inst DATE,
                    consumo REAL,
                    FOREIGN KEY(id_cliente) REFERENCES Cliente(id_cliente),
                    FOREIGN KEY(id_func) REFERENCES Funcionario(id))'''
            ]
            
            for tabela in tabelas:
                self.cursor.execute(tabela)
            self.conn.commit()
            
        except sqlite3.Error as e:
            messagebox.showerror("Erro no Banco de Dados", str(e))

    def create_widgets(self):
        main_frame = ttk.Frame(self.master)
        main_frame.pack(padx=20, pady=20, fill='both', expand=True)

        # Topo
        top_frame = ttk.Frame(main_frame)
        top_frame.pack(fill='x', pady=10)
        
        # Combobox
        self.table_combo = ttk.Combobox(top_frame, width=40)
        self.table_combo.pack(side='left', padx=10)
        self.table_combo.bind('<<ComboboxSelected>>', self.load_columns)

        # Botões
        btn_frame = ttk.Frame(top_frame)
        btn_frame.pack(side='left', padx=10)
        
        ttk.Button(btn_frame, text="Adicionar", command=self.add_record).pack(side='left', padx=5)
        ttk.Button(btn_frame, text="Visualizar", command=self.view_records).pack(side='left', padx=5)

        # Campos de entrada
        self.entry_frame = ttk.LabelFrame(main_frame, text="Campos")
        self.entry_frame.pack(fill='x', pady=10)

        # Treeview
        tree_frame = ttk.Frame(main_frame)
        tree_frame.pack(fill='both', expand=True)
        
        self.tree = ttk.Treeview(tree_frame)
        vsb = ttk.Scrollbar(tree_frame, orient="vertical", command=self.tree.yview)
        hsb = ttk.Scrollbar(tree_frame, orient="horizontal", command=self.tree.xview)
        self.tree.configure(yscrollcommand=vsb.set, xscrollcommand=hsb.set)
        
        self.tree.grid(row=0, column=0, sticky='nsew')
        vsb.grid(row=0, column=1, sticky='ns')
        hsb.grid(row=1, column=0, sticky='ew')
        
        tree_frame.grid_rowconfigure(0, weight=1)
        tree_frame.grid_columnconfigure(0, weight=1)

    def load_tables(self):
        self.cursor.execute("SELECT name FROM sqlite_master WHERE type='table'")
        self.table_combo['values'] = [t[0] for t in self.cursor.fetchall()]

    def load_columns(self, event=None):
        # Limpar campos
        for widget in self.entry_frame.winfo_children():
            widget.destroy()
            
        tabela = self.table_combo.get()
        try:
            # Obter colunas com tratamento de erros
            self.cursor.execute(f'PRAGMA table_info("{tabela}")')
            colunas = [col[1] for col in self.cursor.fetchall()]
            
            if not colunas:
                messagebox.showwarning("Aviso", "Tabela sem colunas!")
                return
                
            # Criar campos de entrada
            self.entries = {}
            for idx, coluna in enumerate(colunas):
                row = ttk.Frame(self.entry_frame)
                row.pack(fill='x', padx=5, pady=2)
                
                lbl = ttk.Label(row, text=coluna, width=20)
                lbl.pack(side='left')
                
                entry = ttk.Entry(row)
                entry.pack(side='left', fill='x', expand=True)
                self.entries[coluna] = entry
                
        except sqlite3.Error as e:
            messagebox.showerror("Erro", f"Falha ao carregar colunas:\n{str(e)}")

    def add_record(self):
        tabela = self.table_combo.get()
        if not tabela:
            messagebox.showerror("Erro", "Selecione uma tabela primeiro!")
            return
            
        colunas = list(self.entries.keys())
        valores = [entry.get() for entry in self.entries.values()]
        
        try:
            # Criar query com tratamento de nomes
            query = f'INSERT INTO "{tabela}" ({", ".join(colunas)}) VALUES ({", ".join(["?"]*len(valores))})'
            self.cursor.execute(query, valores)
            self.conn.commit()
            
            messagebox.showinfo("Sucesso", "Registro adicionado com sucesso!")
            
            # Limpar campos
            for entry in self.entries.values():
                entry.delete(0, 'end')
                
        except sqlite3.Error as e:
            messagebox.showerror("Erro", f"Falha ao inserir registro:\n{str(e)}")

    def view_records(self):
        tabela = self.table_combo.get()
        if not tabela:
            return
            
        self.tree.delete(*self.tree.get_children())
        
        try:
            # Obter colunas
            self.cursor.execute(f'PRAGMA table_info("{tabela}")')
            colunas = [col[1] for col in self.cursor.fetchall()]
            
            # Configurar treeview
            self.tree['columns'] = colunas
            self.tree['show'] = 'headings'
            
            for col in colunas:
                self.tree.heading(col, text=col)
                self.tree.column(col, width=150, stretch=True)
                
            # Carregar dados
            self.cursor.execute(f'SELECT * FROM "{tabela}"')
            for row in self.cursor.fetchall():
                self.tree.insert('', 'end', values=row)
                
        except sqlite3.Error as e:
            messagebox.showerror("Erro", f"Falha ao carregar dados:\n{str(e)}")

    def __del__(self):
        if hasattr(self, 'conn'):
            self.conn.close()

if __name__ == "__main__":
    root = tk.Tk()
    app = DatabaseApp(root)
    root.mainloop()