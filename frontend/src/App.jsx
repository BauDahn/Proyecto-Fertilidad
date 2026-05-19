import React, { useState } from 'react';
import FormularioMedico from './components/FormularioMedico';
import { predict } from './services/api';

function App() {
  const [resultado, setResultado] = useState(null);
  const [cargando, setCargando] = useState(false);
  const [error, setError] = useState(null);

  const manejarEnvio = async (datosPaciente) => {
    setCargando(true);
    setError(null);
    setResultado(null);
    
    try {
      const res = await predict(datosPaciente);
      setResultado(res);
    } catch (err) {
      setError("No se pudo conectar con el servidor médico. Verifique que el backend esté encendido.");
    } finally {
      setCargando(false);
    }
  };

  return (
    <div style={{ 
      fontFamily: 'system-ui, -apple-system, sans-serif', 
      padding: '40px 16px', 
      backgroundColor: '#f8fafc', // Fondo gris clínico muy sutil
      minHeight: '100vh',
      boxSizing: 'border-box',
      display: 'flex',
      flexDirection: 'column',
      alignItems: 'center'
    }}>
      
      {/* Contenedor con límite de ancho */}
      <div style={{ width: '100%', maxWidth: '640px' }}>
        
        <FormularioMedico onEnviar={manejarEnvio} />

        {cargando && (
          <p style={{ textAlign: 'center', color: '#64748b', fontWeight: '600', marginTop: '24px' }}>
            ⏳ Procesando matriz de interacciones en R...
          </p>
        )}

        {error && (
          <div style={{ 
            marginTop: '24px', 
            padding: '16px', 
            backgroundColor: '#fef2f2', 
            color: '#991b1b', 
            borderRadius: '12px', 
            border: '1px solid #fee2e2',
            textAlign: 'center',
            fontSize: '14px',
            fontWeight: '600'
          }}>
            ⚠️ {error}
          </div>
        )}

        {resultado && (
          <div style={{ 
            marginTop: '24px', 
            padding: '24px', 
            backgroundColor: '#ffffff', 
            borderRadius: '16px', 
            boxShadow: '0 10px 25px -5px rgba(0, 0, 0, 0.05)',
            borderTop: '6px solid #10b981', // Verde éxito clínico
            textAlign: 'center'
          }}>
            <h3 style={{ color: '#1e293b', margin: '0 0 16px 0', fontSize: '16px', fontWeight: '700' }}>
              📋 Resultado del Análisis Predictivo
            </h3>
            
            <div style={{ display: 'flex', gap: '16px', justifyContent: 'center' }}>
              <div style={{ padding: '16px', backgroundColor: '#f0fdf4', borderRadius: '12px', flex: 1, border: '1px solid #dcfce7' }}>
                <span style={{ fontSize: '11px', color: '#15803d', fontWeight: '800', display: 'block', letterSpacing: '0.5px', marginBottom: '4px' }}>PRONÓSTICO</span>
                <strong style={{ fontSize: '24px', color: '#166534', fontWeight: '800' }}>{resultado.prediccion}</strong>
              </div>
              
              <div style={{ padding: '16px', backgroundColor: '#f8fafc', borderRadius: '12px', flex: 1, border: '1px solid #e2e8f0' }}>
                <span style={{ fontSize: '11px', color: '#64748b', fontWeight: '800', display: 'block', letterSpacing: '0.5px', marginBottom: '4px' }}>PROBABILIDAD</span>
                <strong style={{ fontSize: '24px', color: '#0f172a', fontWeight: '800' }}>{(resultado.probabilidad * 100).toFixed(2)}%</strong>
              </div>
            </div>
          </div>
        )}
      </div>
    </div>
  );
}

export default App;