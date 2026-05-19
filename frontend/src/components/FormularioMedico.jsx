import React, { useState } from 'react';

const FormularioMedico = ({ onEnviar }) => {
  const [formData, setFormData] = useState({
    treatment_type: 'Natural',
    pcos: false,
    motility_percentage: 30.0,
    sperm_count_millon_per_ml: 20.0, // Asegúrate de que coincida con el nombre exacto de tu backend
    stress_level: 'Low',
    female_age: 30, // Asegúrate de que coincida con tu backend
    smoking: false,
  });

  const handleChange = (e) => {
    const { name, value, type, checked } = e.target;
    setFormData((prev) => ({
      ...prev,
      [name]: type === 'checkbox' ? checked : (type === 'number' ? parseFloat(value) : value),
    }));
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    onEnviar(formData);
  };

  // Estilos reutilizables en línea
  const inputEstilo = {
    width: '100%',
    padding: '10px 12px',
    borderRadius: '8px',
    border: '1px solid #cbd5e1',
    backgroundColor: '#ffffff',
    color: '#334155',
    fontSize: '14px',
    fontWeight: '600',
    marginTop: '6px',
    boxSizing: 'border-box',
    outline: 'none',
    transition: 'border-color 0.2s'
  };

  const labelEstilo = {
    fontSize: '14px',
    fontWeight: '700',
    color: '#475569',
    display: 'block'
  };

  return (
    <div style={{
      backgroundColor: '#ffffff',
      padding: '32px',
      borderRadius: '16px',
      boxShadow: '0 10px 25px -5px rgba(0, 0, 0, 0.05), 0 8px 10px -6px rgba(0, 0, 0, 0.05)',
      border: '1px solid #f1f5f9'
    }}>
      <div style={{ textAlign: 'center', marginBottom: '28px' }}>
        <h2 style={{ fontSize: '24px', fontWeight: '800', color: '#1e293b', margin: '0 0 6px 0' }}>
          🧬 Predicción de Fertilidad Clínica
        </h2>
        <p style={{ fontSize: '14px', color: '#64748b', margin: 0 }}>
          Ingrese los parámetros del paciente para evaluar la probabilidad de éxito.
        </p>
      </div>

      <form onSubmit={handleSubmit} style={{ display: 'flex', flexDirection: 'column', gap: '20px' }}>
        
        {/* Cuadrícula de Parámetros */}
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(200px, 1fr))', gap: '20px', textAlign: 'left' }}>
          
          <div>
            <label style={labelEstilo}>Tipo de Tratamiento</label>
            <select name="treatment_type" value={formData.treatment_type} onChange={handleChange} style={inputEstilo}>
              <option value="Natural">Natural / Referencia</option>
              <option value="Medication">Medicación</option>
              <option value="IVF">FIV (IVF)</option>
            </select>
          </div>

          <div>
            <label style={labelEstilo}>Nivel de Estrés</label>
            <select name="stress_level" value={formData.stress_level} onChange={handleChange} style={inputEstilo}>
              <option value="Low">Bajo (Low)</option>
              <option value="Medium">Medio (Medium)</option>
              <option value="High">Alto (High)</option>
            </select>
          </div>

          <div>
            <label style={labelEstilo}>Edad de la Mujer</label>
            <input type="number" name="female_age" value={formData.female_age} onChange={handleChange} style={inputEstilo} />
          </div>

          <div>
            <label style={labelEstilo}>Porcentaje de Motilidad (%)</label>
            <input type="number" step="0.1" name="motility_percentage" value={formData.motility_percentage} onChange={handleChange} style={inputEstilo} />
          </div>

          <div style={{ gridColumn: 'span 1' }}>
            <label style={labelEstilo}>Conteo Espermático (M/ml)</label>
            <input type="number" step="0.1" name="sperm_count_millon_per_ml" value={formData.sperm_count_millon_per_ml} onChange={handleChange} style={inputEstilo} />
          </div>

        </div>

        {/* Sección de Antecedentes / Condiciones (Checkboxes elegantes) */}
        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '12px', marginTop: '8px', textAlign: 'left' }}>
          
          <label style={{
            display: 'flex',
            alignItems: 'center',
            padding: '12px 16px',
            borderRadius: '10px',
            border: '1px solid #e2e8f0',
            backgroundColor: formData.pcos ? '#f5f3ff' : '#fafafa',
            borderColor: formData.pcos ? '#c084fc' : '#e2e8f0',
            cursor: 'pointer',
            transition: 'all 0.2s'
          }}>
            <input type="checkbox" name="pcos" checked={formData.pcos} onChange={handleChange} style={{ width: '18px', height: '18px', accentColor: '#a855f7', cursor: 'pointer' }} />
            <span style={{ ml: '12px', fontSize: '14px', fontWeight: '600', color: '#334155', marginLeft: '10px' }}>⚠️ ¿Sufre de SOP (PCOS)?</span>
          </label>

          <label style={{
            display: 'flex',
            alignItems: 'center',
            padding: '12px 16px',
            borderRadius: '10px',
            border: '1px solid #e2e8f0',
            backgroundColor: formData.smoking ? '#fff1f2' : '#fafafa',
            borderColor: formData.smoking ? '#fda4af' : '#e2e8f0',
            cursor: 'pointer',
            transition: 'all 0.2s'
          }}>
            <input type="checkbox" name="smoking" checked={formData.smoking} onChange={handleChange} style={{ width: '18px', height: '18px', accentColor: '#f43f5e', cursor: 'pointer' }} />
            <span style={{ ml: '12px', fontSize: '14px', fontWeight: '600', color: '#334155', marginLeft: '10px' }}>🚬 ¿Es fumadora?</span>
          </label>

        </div>

        {/* Botón de envío */}
        <button type="submit" style={{
          backgroundColor: '#4f46e5',
          color: '#ffffff',
          border: 'none',
          padding: '14px',
          borderRadius: '10px',
          fontSize: '16px',
          fontWeight: '700',
          cursor: 'pointer',
          boxShadow: '0 4px 6px -1px rgba(79, 70, 229, 0.2)',
          transition: 'background-color 0.2s, transform 0.1s',
          marginTop: '10px'
        }}
        onMouseEnter={(e) => e.target.style.backgroundColor = '#4338ca'}
        onMouseLeave={(e) => e.target.style.backgroundColor = '#4f46e5'}
        >
          Calcular Probabilidad Predictiva
        </button>

      </form>
    </div>
  );
};

export default FormularioMedico;