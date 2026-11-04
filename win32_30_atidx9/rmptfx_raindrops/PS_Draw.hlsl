float4 ColorCorrectBottomOffset : register(c44);
float4 ColorCorrectBottomOffsetScreenEdge : register(c67);
float4 ColorCorrectTopAndPedReflectScale : register(c43);
float4 ColorCorrectTopScreenEdge : register(c66);
float4 ColorShift : register(c45);
sampler2D DiffuseTexSampler : register(s0);
float HybridAdd : register(c89);
float4 deSatContrastGamma : register(c46);
float4 gAdrenoFXVars : register(c68);
float4 globalScalars4 : register(c51);
float4 globalScreenSize : register(c41);

struct PS_IN
{
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord4 : TEXCOORD4;
	float2 vpos : VPOS;
	float4 texcoord2 : TEXCOORD2;
};

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	float4 r2;
	float4 r3;
	float4 r4;
	float3 r5;
	r0 = ColorCorrectTopScreenEdge;
	r0.w = r0.w + -ColorCorrectBottomOffsetScreenEdge.w;
	r0.w = (r0.w >= 0) ? -r0.w : -0;
	r1.x = r0.w + ColorCorrectTopScreenEdge.w;
	r1.x = 1 / r1.x;
	r1.y = 1 / globalScreenSize.x;
	r2.x = r1.y * i.vpos.x;
	r1.y = 1 / globalScreenSize.y;
	r2.y = r1.y * i.vpos.y;
	r1.yz = r2.xy + -0.5;
	r1.y = dot(r1.yz, r1.yz) + 0;
	r1.y = rsqrt(r1.y);
	r1.y = 1 / r1.y;
	r0.w = r0.w + r1.y;
	r1.x = saturate(r1.x * r0.w);
	r0.w = (r0.w >= 0) ? r1.x : 0;
	r1 = tex2D(DiffuseTexSampler, i.texcoord1.xy);
	r3 = tex2D(DiffuseTexSampler, i.texcoord1.zw);
	r4 = lerp(r1, r3, 0.5);
	r1 = r4 * i.texcoord;
	r2.x = dot(r1.xyz, float3(0.2125, 0.7154, 0.0721));
	r1.w = saturate(r1.w);
	r3.xyz = r4.xyz * i.texcoord.xyz + -r2.xxx;
	r3.xyz = i.texcoord2.zzz * r3.xyz + r2.xxx;
	r2.x = r2.x + 1E-05;
	r2.x = abs(r2.x) + 1E-05;
	r2.z = -0.99999 + i.texcoord2.w;
	r3.w = pow(r2.x, r2.z);
	r2.xzw = r3.www * r3.xyz;
	r3.xyz = r3.xyz * -r3.www + i.texcoord4.xyz;
	r2.xzw = i.texcoord4.www * r3.xyz + r2.xzw;
	r3.x = dot(r2.xzw, float3(0.2125, 0.7154, 0.0721));
	r4.x = gAdrenoFXVars.x;
	r3.y = r4.x * deSatContrastGamma.x;
	r4.xyz = lerp(r3.xxx, r2.xzw, r3.yyy);
	r2.x = r3.x * ColorCorrectBottomOffset.w;
	r2.z = r3.x * ColorShift.w;
	r3.xyz = globalScalars4.yzw * -r2.xxx + r4.xyz;
	r4.xyz = ColorShift.xyz * -r2.zzz + r4.xyz;
	r5 = r2.xxx * globalScalars4.yzw;
	r2.x = saturate(r2.x);
	r3.xyz = r2.xxx * r3.xyz + r5.xyz;
	r0.xyz = r2.yyy * ColorCorrectBottomOffsetScreenEdge.xyz + r0.xyz;
	r5 = ColorCorrectBottomOffset.xyz;
	r2.xyw = r2.yyy * r5.xyz + ColorCorrectTopAndPedReflectScale.xyz;
	r3.xyz = r0.xyz * r3.xyz;
	r0.xyz = r2.zzz * ColorShift.xyz;
	r2.z = saturate(r2.z);
	r0.xyz = r2.zzz * r4.xyz + r0.xyz;
	r1.xyz = r2.xyw * r0.xyz;
	r3.w = r1.w;
	r2 = lerp(r1, r3, r0.w);
	r0 = (ColorCorrectTopScreenEdge.w >= 0) ? r2 : r1;
	r1.xyz = r0.www * r0.xyz;
	r1.w = r0.w;
	r2.x = abs(HybridAdd.x);
	r0 = (-r2.x >= 0) ? r0 : r1;
	o = max(r0, 0);

	return o;
}
